import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/controller_service.dart';
import 'package:gru_minions/service/controller_status.dart';

abstract class ControllerBaseWidgetState<T extends StatefulWidget> extends State<T> {
  late ControllerService controllerService;

  Widget content(BuildContext context);

  @override
  void initState() {
    super.initState();
    controllerService = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controllerService.bossStatus.value) {
          case ControllerStatus.initializing:
            return _loading(subText: 'Initialisation...');
          case ControllerStatus.creatingGroup:
            return _loading(subText: 'Création du groupe...');
          case ControllerStatus.openingSocket:
            return _loading(subText: 'Ouverture du socket...');
          case ControllerStatus.active:
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
