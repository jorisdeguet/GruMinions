import 'dart:ui';

import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/modes/flame.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/widget/boss_base_widget.dart';

import '../modes/base-mode.dart';
import '../modes/list_of_modes.dart';
import '../modes/synchro.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _MainBossPageState();
}

class _MainBossPageState extends BossBaseWidgetState<ControlPage> {
  final bool _messagesDebug = true;

  final List<String> _messages = [];

  final List<String> _levels = [
    '01', '02', '03', '04', '05', '06', '07', '08', '09', '10',
    '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
    '21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
  ];
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
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 20,
              children: _levels.map(_buttonForLevel).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonForLevel(String level) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SpriteButton.asset(
        onPressed: () {
          changeMode(level);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => _currentMode.controllerWidget()
              )
          );
        },
        label: const Text(''),
        path: 'Menu/Levels/$level.png',
        pressedPath: 'Menu/Levels/$level.png',
        width: 40,
        height: 40,
      ),
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
