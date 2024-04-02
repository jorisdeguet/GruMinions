import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/controller_service.dart';
import 'package:gru_minions/service/controller_status.dart';
import 'package:mac_address/mac_address.dart';

abstract class ControllerBaseWidgetState<T extends StatefulWidget> extends State<T> {
  late ControllerService controllerService;

  List<String> logs = [];

  Widget content(BuildContext context);

  String _macAddress = "no mac";

  void _initMac() async {
    _macAddress = await GetMac.macAddress;
    setState(() {});
  }

  String macAddress() => _macAddress;

  @override
  void initState() {
    super.initState();
    _initMac();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    controllerService = Get.find();
  }

  @override
  @nonVirtual
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controllerService.minionStatus.value) {
          case ControllerStatus.initializing:
            return _loading(subText: '${macAddress()} Initialisation...');
          case ControllerStatus.searchingBoss:
            return _loading(subText: '${macAddress()} Recherche de Gru...');
          case ControllerStatus.connectingBoss:
            return _loading(subText: '${macAddress()} Connection à Gru...');
          case ControllerStatus.connectingSocket:
            return _loading(
                subText: '${macAddress()} Connection au socket de Gru...');
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
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: 80,
                                width: 80,
                                child: CircularProgressIndicator(
                                  strokeWidth: 10,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(subText ?? 'Chargement...'),
                          ),
                        ],
                      )),
                  controllerService.grus.length < 2
                      ? Container()
                      : Expanded(
                      child: ListView(
                        children: controllerService.grus.map((gru) {
                          return ListTile(
                            title: Text(gru.deviceName),
                            subtitle: Text(gru.deviceAddress),
                            trailing: ElevatedButton.icon(
                                onPressed: () {
                                  controllerService.initiateConnectionToGru(gru);
                                },
                                icon: const Icon(Icons.wifi_find),
                                label: const Text("connect")),
                          );
                        }).toList(),
                      ))
                ],
              )),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: controllerService.logs
                      .map((e) => Text(
                    e,
                    style: const TextStyle(color: Colors.white60),
                  ))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
