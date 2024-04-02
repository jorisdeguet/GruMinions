import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/screen_status.dart';

import '../service/screen_service.dart';

abstract class ScreenBaseWidgetState<T extends StatefulWidget>
    extends State<T> {
  late ScreenService viewService;
  Widget content(BuildContext context);

  @override
  void initState() {
    super.initState();
    viewService = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (viewService.bossStatus.value) {
          case ViewStatus.initializing:
            return _loading(subText: 'Initialisation...');
          case ViewStatus.creatingGroup:
            return _loading(subText: 'Création du groupe...');
          case ViewStatus.openingSocket:
            return _loading(subText: 'Ouverture du socket...');
          case ViewStatus.active:
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
