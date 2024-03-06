import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/widget/boss_base_widget.dart';

import '../modes/base-mode.dart';
import '../modes/list_of_modes.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _MainBossPageState();
}

class _MainBossPageState extends BossBaseWidgetState<ControlPage> {
  final bool _messagesDebug = true;

  final List<String> _messages = [];

  late final List<GruMinionMode> _modes = listOfModes(_send);
  late GruMinionMode _currentMode;

  void changeMode(String m) {
    for (GruMinionMode mode in _modes) {
      if (m == mode.name()) _currentMode = mode;
    }
    _send(m);
    _currentMode.initGru();
    setState(() {});
  }

  @override
  void initState() {
    Get.put(GruService());
    GruService service = Get.find<GruService>();
    service.onReceive.listen((element) {
      _receive(element);
    });
    changeMode(_modes[0].name());
    super.initState();
  }

  @override
  Widget content(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
            "Gru mode ${_currentMode.name()} @${_currentMode.macAddress()}"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                _gestionDesModes(),
                _messagesDebug ? _messagesList() : Container(),
              ],
            ),
          ),
          Expanded(child: _currentMode.gruWidget()),
        ],
      ),
    );
  }

  Expanded _gestionDesModes() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        children: _modes.map(_buttonForMode).toList(),
      ),
    );
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

  Widget _buttonForMode(GruMinionMode e) {
    return MaterialButton(
        color: Colors.greenAccent,
        onPressed: () {
          changeMode(e.name());
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Text(
            e.name(),
            style: const TextStyle(fontSize: 15),
          ),
        ));
  }

  Widget _messagesList() {
    return Expanded(
      child: Column(
        children: [
          MaterialButton(
            color: Colors.red,
            onPressed: () {
              _messages.clear();
              setState(() {});
            },
            child: const Text("Effacer"),
          ),
          Expanded(
            child: ListView(
              children: _messages.map((e) => Text(e)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}