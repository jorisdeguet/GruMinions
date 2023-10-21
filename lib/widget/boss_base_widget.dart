import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/boss_service.dart';
import 'package:gru_minions/service/boss_status.dart';

abstract class BossBaseWidgetState<T extends StatefulWidget> extends State<T> {
  late GruService bossService;

  Widget content(BuildContext context);

  @override
  void initState() {
    super.initState();
    bossService = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (bossService.bossStatus.value) {
          case BossStatus.initializing:
            return _loading(subText: 'Initialisation...');
          case BossStatus.creatingGroup:
            return _loading(subText: 'Création du groupe...');
          case BossStatus.openingSocket:
            return _loading(subText: 'Ouverture du socket...');
          case BossStatus.active:
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
