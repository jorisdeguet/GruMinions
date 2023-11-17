import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/base_network_service.dart';

import 'minion_status.dart';

// Quand on a un reasoncode= 2 c'est https://developer.android.com/reference/android/net/wifi/p2p/WifiP2pManager#BUSY
// https://developer.android.com/reference/android/net/wifi/p2p/WifiP2pManager.ActionListener#onFailure(int)

// TODO show a trace of all actions during minion connection to be able to follow what happens on screen
class MinionService extends BaseNetworkService {

  Rx<MinionStatus> minionStatus = MinionStatus.none.obs;
  Rx<String> onReceive = ''.obs;

  bool _connectingToBoss = false;
  bool _connectingToBossSocket = false;
  bool _connected = false;

  List<DiscoveredPeers> _peers = [];
  List<DiscoveredPeers> grus = [];


  StreamSubscription<List<DiscoveredPeers>>? _peerStream;
  StreamSubscription<WifiP2PInfo>? _wifiP2PInfoStream;

  List<String> logs = [];

  MinionService() {
    _init();
  }

  void _log(String message) {
    debugPrint(message);
    logs.add(message);
  }

  void _init() async {
    minionStatus.value = MinionStatus.initializing;

    await Future.delayed(const Duration(seconds: 1));
    await p2p.initialize();
    await p2p.register();
    await Future.delayed(const Duration(seconds: 1));
    // see if a group exists
    var groupInfo = await p2p.groupInfo();
    _log("Minion init got group info " + groupInfo.toString() + " ");
    if (groupInfo != null) {
      _log("Minion init initiating existing group removal ");
      bool removalOk = await p2p.removeGroup();
      _log("Minion init delete existing group status " + removalOk.toString());
    }
    _log("Minion init initiating peers discovery ");
    bool discoverOk = await p2p.discover();
    _log("Minion init discovery status " + discoverOk.toString());

    _peerStream = p2p.streamPeers().listen((List<DiscoveredPeers> event) {
      // TODO on ne veut pas forcément passer dans ce mode non?
      _log('Minion Service got peers' + _connected.toString() + " " + _connectingToBoss.toString());
      if (minionStatus.value != MinionStatus.active) {
        minionStatus.value = MinionStatus.searchingBoss;
        _peers = event;
        _log('Minion Service got peers' + _peers.toString());
        grus =
        event.where((DiscoveredPeers peer) => peer.isGroupOwner).toList();
        _log('Minion Service got Grus' + grus.toString());
        if (grus.length > 1) {
          // TODO add a selector on the right with the grus to connect to
          _log('Minion Service ===================================== Too many Grus');
          for (var g in grus) {
            _log('Minion Service ' + g.deviceAddress);
          }
        } else if (grus.length == 1 && !_connectingToBoss) {
          // Automatically connects as we do see a single Gru
          DiscoveredPeers gru = grus.first;
          initiateConnectionToGru(gru);
        }
      }
    });

    _wifiP2PInfoStream = p2p.streamWifiP2PInfo().listen((WifiP2PInfo event) {
      if (!_connected &&
          !_connectingToBossSocket &&
          event.groupOwnerAddress != "") {
        _log('Minion Service connection to socket initiated');
        _connectingToBossSocket = true;
        connectToSocket(event);
      }
    });
  }

  void initiateConnectionToGru(DiscoveredPeers gru) {
    _log('Minion Service connecting to Gru ' + gru.deviceAddress.toString());
    _connectingToBoss = true;
    minionStatus.value = MinionStatus.connectingBoss;
    p2p.connect(gru.deviceAddress).then((bool value) {
      _log('Minion Service connection is ' + value.toString());
    });
  }

  Future connectToSocket(WifiP2PInfo info) async {
    minionStatus.value = MinionStatus.connectingSocket;
    bool succeeded = false;
    while (!succeeded) {
      succeeded = await p2p.connectToSocket(
        groupOwnerAddress: info.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 2,
        deleteOnError: true,
        onConnect: (String address) {
          _connected = true;
          minionStatus.value = MinionStatus.active;
          print(info);
          DiscoveredPeers boss =
              _peers.firstWhere((DiscoveredPeers peer) => peer.isGroupOwner);
          _log('Minion Service connected to Gru');
        },
        transferUpdate: (transfer) {
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (message) async {
          //print('Minion got message  ' + message.toString());
          onReceive.value = message;
          // onReceive.trigger(message);
        },
      );
    }
  }

  @override
  void dispose() {
    if (_peerStream != null) {
      _peerStream!.cancel();
    }
    if (_wifiP2PInfoStream != null) {
      _wifiP2PInfoStream!.cancel();
    }
    super.dispose();
  }
}
