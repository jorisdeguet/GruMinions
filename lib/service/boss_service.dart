import 'dart:async';

import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/base_network_service.dart';
import 'package:gru_minions/service/boss_status.dart';

class GruService extends BaseNetworkService {
  Rx<BossStatus> bossStatus = BossStatus.none.obs;
  Rx<String> onReceive = ''.obs;

  bool _creatingGroup = false;
  bool _groupCreated = false;

  StreamSubscription<WifiP2PInfo>? _wifiP2PInfoStream;

  WifiP2PInfo? info;

  GruService() {
    init();
  }

  Future<void> init() async {
    bossStatus.value = BossStatus.initializing;

    await p2p.initialize();
    await p2p.register();

    await p2p.removeGroup();

    _wifiP2PInfoStream = p2p.streamWifiP2PInfo().listen((WifiP2PInfo event) {
      info = event;
      if (!_groupCreated && event.groupFormed) {
        _groupCreated = true;
        _creatingGroup = false;
        _startBossSocket(event);
        List<String> foundClients =
            event.clients.map((Client e) => e.deviceName).toList();
        print('Group created');
        print('  ip : ${event.groupOwnerAddress}');
        print('  clients : $foundClients');
      } else if (!_creatingGroup && !_groupCreated) {
        bossStatus.value = BossStatus.creatingGroup;
        _creatingGroup = true;
        p2p.createGroup();
      }
    });
  }

  Future _startBossSocket(WifiP2PInfo info) async {
      bossStatus.value = BossStatus.openingSocket;
      await p2p.startSocket(
        groupOwnerAddress: info.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 64,
        deleteOnError: true,
        onConnect: (String name, String address) {
          print("$name connected to socket with address: $address");
        },
        transferUpdate: (transfer) {
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        // handle string transfer from server
        receiveString: (dynamic message) async {
          //print("Gru got message " + message);
          onReceive.value = message;
        },
      );
      bossStatus.value = BossStatus.active;
  }

  @override
  void dispose() {
    if(_wifiP2PInfoStream != null) {
      _wifiP2PInfoStream!.cancel();
    }
    super.dispose();
  }
}
