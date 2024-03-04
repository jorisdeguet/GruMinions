import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/widget/boss_base_widget.dart';

import '../modes/base-mode.dart';
import '../modes/list_of_modes.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({super.key});

  @override
  State<ControllerPage> createState() => _MainBossPageState();
}

class _MainBossPageState extends BossBaseWidgetState<ControllerPage> {
  final bool _messagesDebug = true;
  late bool _isStarted = false;

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
      body: Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // Add your logic for moving left here
                    },
                  ),
                  const SizedBox(width: 20), // Add some spacing between buttons
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      // Add your logic for moving right here
                    },
                  ),
                ],
              ),
            ), // Add some spacing between buttons
            GestureDetector(
              onTap: () {
                // Add your logic for jumping here
                if(!_isStarted){
                  changeMode('flame');
                  _isStarted = true;
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: Text('Jump', style: TextStyle(color: Colors.white))),
                ),
              ),
            ),
          ],
        ),
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

