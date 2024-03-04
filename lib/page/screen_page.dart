import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/list_of_modes.dart';
import 'package:gru_minions/service/minion_service.dart';
import 'package:gru_minions/widget/minion_base_widget.dart';

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends MinionBaseWidgetState<ScreenPage> {
  late final List<GruMinionMode> _modes = listOfModes(_send);

  late GruMinionMode _currentMode = _modes[0];

  @override
  void initState() {
    Get.put(MinionService());
    super.initState();
    Get.find<MinionService>().onReceive.listen((element) {
      _receive(element);
    });
  }

  @override
  Widget content(BuildContext context) {
    return _mainBody();
  }

  Widget _mainBody() {
    return _currentMode.minionWidget(context);
  }

  void changeMode(String m) {
    for (GruMinionMode mode in _modes) {
      if (m == mode.name()) {
        print("Minion mode changed to $m");
        _currentMode = mode;
        _currentMode.initMinion();
      }
    }
    setState(() {});
  }

  void _send(String m) {
    Get.find<MinionService>().p2p.sendStringToSocket(m);
    setState(() {});
  }

  void _receive(String m) {
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
