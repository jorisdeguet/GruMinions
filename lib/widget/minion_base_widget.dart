import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/minion_status.dart';
import 'package:mac_address/mac_address.dart';

import '../service/minion_service.dart';

abstract class MinionBaseWidgetState<T extends StatefulWidget> extends State<T> {
  late MinionService minionService;

  List<String> logs = [];

  Widget content(BuildContext context);


  String _macAddress = "no mac";
  void _initMac() async {
    _macAddress = await GetMac.macAddress ?? 'Unknown mac address';
    setState(() {});
  }
  String macAddress() => _macAddress;

  @override
  void initState() {
    super.initState();
    _initMac();
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
            return _loading(subText: macAddress() + ' Initialisation...');
          case MinionStatus.searchingBoss:
            return _loading(subText: macAddress() + ' Recherche de Gru...');
          case MinionStatus.connectingBoss:
            return _loading(subText: macAddress() + ' Connection à Gru...');
          case MinionStatus.connectingSocket:
            return _loading(subText: macAddress() + ' Connection au socket de Gru...');
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
          Expanded(
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const SizedBox(
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
                      )
                  ),
                  minionService.grus.length < 2 ? Container():
                  Expanded(
                      child: ListView(
                        children : minionService.grus.map(
                            (gru) {
                              return ListTile(
                                title: Text(gru.deviceName),
                                subtitle: Text(gru.deviceAddress),
                                trailing: ElevatedButton.icon(
                                    onPressed: () {
                                        minionService.initiateConnectionToGru(gru);
                                    },
                                    icon: Icon(Icons.wifi_find),
                                    label: Text("connect")
                                ),
                              );
                            }

                        ).toList(),
                      )
                  )
                ],
              )
          ),
          Expanded(
            flex:2,
            child: Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: minionService.logs.map(
                          (e) => Text(e, style: TextStyle(color: Colors.white60),)
                  ).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
