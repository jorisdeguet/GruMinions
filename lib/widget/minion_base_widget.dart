import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/minion_status.dart';

import '../service/minion_service.dart';

abstract class MinionBaseWidgetState<T extends StatefulWidget> extends State<T> {
  late MinionService minionService;

  Widget content(BuildContext context);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    minionService = Get.find();
  }

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (minionService.minionStatus.value) {
          case MinionStatus.initializing:
            return _loading(subText: 'Initialisation...');
          case MinionStatus.searchingBoss:
            return _loading(subText: 'Recherche de Gru...');
          case MinionStatus.connectingBoss:
            return _loading(subText: 'Connection à Gru...');
          case MinionStatus.connectingSocket:
            return _loading(subText: 'Connection au socket de Gru...');
          case MinionStatus.active:
            return content(context);
          default:
            return _loading();
        }
      }),
    );
  }

  Widget _loading({String? subText}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(
                strokeWidth: 10,
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(subText ?? 'Chargement...'),
          )
        ],
      ),
    );
  }
}
