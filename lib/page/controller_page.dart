
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/player/character_mode.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/widget/boss_base_widget.dart';

import '../modes/base/base-mode.dart';
import '../modes/list_of_modes.dart';

class Controller extends StatefulWidget {
  const Controller({super.key});

  @override
  State<Controller> createState() => _MainBossPageState();
}

class _MainBossPageState extends BossBaseWidgetState<Controller> {
  final List<String> _messages = [];
  late final List<GruMinionMode> _modes = listOfModes(_send);
  late GruMinionMode _currentMode;

  @override
  void initState() {
    Get.put(GruService());
    GruService service = Get.find<GruService>();
    service.onReceive.listen((element) {
      _receive(element);
    });
    _currentMode = CharacterMode(sendToOthers: _send);
    _currentMode.initController();
    super.initState();
  }

  @override
  Widget content(BuildContext context) {
    return _currentMode.controllerWidget();
  }

  void changeMode(String m) {
    for (GruMinionMode mode in _modes) {
      if (m == mode.name()) {
        _currentMode = mode;
        _currentMode.initController();
      }
    }
    setState(() {});
  }

  void _send(String m) {
    _messages.insert(0, "Gru - $m");
    Get.find<GruService>().p2p.sendStringToSocket(m);
    setState(() {});
  }

  void _receive(String m) {
    try {
      _messages.insert(0, "Minion - $m");
      _currentMode.handleMessageAsGru(m);
    } catch (e) {
      print("Minion got exception while handling message $m");
      e.printError();
    }
    setState(() {});
  }
}
