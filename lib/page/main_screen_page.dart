import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/list_of_modes.dart';
import 'package:gru_minions/service/minion_service.dart';
import 'package:gru_minions/widget/minion_base_widget.dart';

class MainScreenPage extends StatefulWidget {
  const MainScreenPage({super.key});

  @override
  State<MainScreenPage> createState() => _MainScreenPageState();
}

class _MainScreenPageState extends MinionBaseWidgetState<MainScreenPage> {
  late final List<GruMinionMode> _modes = listOfModes(_sendTCP,_sendUDP);

  //Todo: Add a HomeScreen instead of booting directly to the first mode
  late GruMinionMode _currentMode = _modes[0];

  @override
  void initState() {
    Get.put(MinionService());
    super.initState();
    MinionService service = Get.find<MinionService>();

    service.onReceive.listen((element) {
      _receiveTCP(element);
    });
    service.udpSetupCompleter.future.then((_) {
      service.udpMessageController.stream.listen((String message) {
        _receiveUDP(message);
      });
    });
  }

  @override
  Widget content(BuildContext context) {
    return _mainBody();
  }

  Widget _mainBody() {
    return _currentMode.screenWidget(context);
  }

  void changeMode(String m) {
    for (GruMinionMode mode in _modes) {
      if (m == mode.name()) {
        print("Screen mode changed to $m");
        _currentMode = mode;
        _currentMode.initMinion();
      }
    }
    setState(() {});
  }

  void _sendTCP(String m) {
    Get.find<MinionService>().p2p.sendStringToSocket(m);
    setState(() {});
  }

  void _receiveTCP(String m) {
    try {
      changeMode(m);
      _currentMode.handleMessageAsMinion(m);
    } catch (e) {
      print("TCP Minion got exception while handling message $m  $e");
      e.printError();
    }
    setState(() {});
  }

  void _sendUDP(String message) {
    Get.find<MinionService>().sendUdp(message);
    setState(() {});
  }

  void _receiveUDP(String m) {
    try {
      changeMode(m);
      _currentMode.handleMessageAsMinion(m);
    } catch (e) {
      print("Minion got exception while handling message $m  $e");
      e.printError();
    }
    setState(() {});
  }
}
