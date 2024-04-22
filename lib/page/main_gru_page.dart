import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/widget/boss_base_widget.dart';

import '../modes/base-mode.dart';
import 'package:gru_minions/modes/list_of_modes.dart';

class MainGruPage extends StatefulWidget {
  const MainGruPage({super.key});

  @override
  State<MainGruPage> createState() => _MainBossPageState();
}

class _MainBossPageState extends BossBaseWidgetState<MainGruPage> {
  final bool _messagesDebug = true;

  final List<String> _messages = [];

  late final List<GruMinionMode> _modes = listOfModes(_sendTCP, _sendUDP).where((element) => !element.name().contains('MainMenu')).toList();
  late GruMinionMode _currentMode;

  void changeMode(String m) {
    for (GruMinionMode mode in _modes) {
      if (m == mode.name()) _currentMode = mode;
    }
    _sendTCP(m);
    _currentMode.initGru();
    setState(() {});
  }

  @override
  void initState() {
    Get.put(GruService());
    GruService service = Get.find<GruService>();
    service.onReceive.listen((element) {
      _receiveTCP(element);
    });
    service.udpSetupCompleter.future.then((_) {
      service.udpMessageController.stream.listen((String message) {
        _receiveUDP(message);
      });
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

  void _sendTCP(String m) {
    _messages.insert(0, "Gru - $m");
    Get.find<GruService>().p2p.sendStringToSocket(m);
    setState(() {});
  }

  void _receiveTCP(String m) {
    try {
      _messages.insert(0, "Minion - $m");
      _currentMode.handleMessageAsGru(m);
    } catch (e) {
      print("Minion got exception while handling message $m");
      e.printError();
    }
    setState(() {});
  }

  void _sendUDP(String message) {
    Get.find<GruService>().sendUdp(message);
    setState(() {});
  }

  void _receiveUDP(String m) {
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/${e.name()}.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: TextButton(
          onPressed: () {
            changeMode(e.name());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: Text(
              e.name(),
              style: const TextStyle(fontSize: 15, color: Colors.black, backgroundColor: Color.fromRGBO(255, 255, 255, 0.5)),
            ),
          )),
    );
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
