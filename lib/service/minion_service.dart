import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/base_network_service.dart';

import 'minion_status.dart';

class MinionService extends BaseNetworkService {

  Rx<MinionStatus> minionStatus = MinionStatus.none.obs;
  Rx<String> onReceive = ''.obs;

  bool _connectingToBoss = false;
  bool _connectingToBossSocket = false;
  bool _connected = false;

  List<DiscoveredPeers> _peers = [];



  StreamSubscription<List<DiscoveredPeers>>? _peerStream;
  StreamSubscription<WifiP2PInfo>? _wifiP2PInfoStream;

  MinionService() {
    _init();
  }

  void _init() async {
    minionStatus.value = MinionStatus.initializing;

    await Future.delayed(const Duration(seconds: 3));
    await p2p.initialize();
    await p2p.register();

    await p2p.removeGroup();
    await p2p.discover();

    _peerStream = p2p.streamPeers().listen((List<DiscoveredPeers> event) {
      minionStatus.value = MinionStatus.searchingBoss;
      _peers = event;
      Iterable<DiscoveredPeers> bosses =
          event.where((DiscoveredPeers peer) => peer.isGroupOwner);
      if (bosses.length > 1) {
        print('Plusieurs boss trouvés');
      } else if (bosses.length == 1 && !_connectingToBoss) {
        DiscoveredPeers boss = bosses.first;
        print(boss);
        _connectingToBoss = true;
        minionStatus.value = MinionStatus.connectingBoss;
        p2p.connect(boss.deviceAddress).then((bool value) {
          print(value);
          // connectToSocket();
        });
      }
    });

    _wifiP2PInfoStream = p2p.streamWifiP2PInfo().listen((WifiP2PInfo event) {
      if (!_connected &&
          !_connectingToBossSocket &&
          event.groupOwnerAddress != "") {
        _connectingToBossSocket = true;
        connectToSocket(event);
      }
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
          Get.snackbar(
            boss.deviceName,
            'Connecté',
            colorText: Colors.white,
            backgroundColor: Colors.lightBlue,
            icon: const Icon(Icons.phone_android),
          );
          print('Connecté à Gru');
        },
        transferUpdate: (transfer) {
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (message) async {
          print('Minion got message  ' + message.toString());
          onReceive.value = message;
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
