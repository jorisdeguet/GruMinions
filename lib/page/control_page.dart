
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/flame.dart';
import 'package:gru_minions/modes/flame/game/choose_character.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/widget/boss_base_widget.dart';

import '../modes/base-mode.dart';
import '../modes/synchro.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _MainBossPageState();
}

class _MainBossPageState extends BossBaseWidgetState<ControlPage> {
  final List<String> _messages = [];
  late GruMinionMode _currentMode;

  @override
  void initState() {
    Get.put(GruService());
    GruService service = Get.find<GruService>();
    service.onReceive.listen((element) {
      _receive(element);
    });
    _currentMode = SyncMode(sendToOthers: _send);
    super.initState();
  }

  @override
  Widget content(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
              "Controller ${_currentMode.name()} @${_currentMode.macAddress()}"),
        ),
      ),
      body: const ChooseCharacter(),
    );
  }

  void changeMode(String m) {
    _currentMode = FlameMode(sendToOthers: _send);
    _send(m);
    _currentMode.initController();
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
