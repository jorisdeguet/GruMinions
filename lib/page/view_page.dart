import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/flame.dart';
import 'package:gru_minions/modes/list_of_modes.dart';
import 'package:gru_minions/service/minion_service.dart';
import 'package:gru_minions/widget/minion_base_widget.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({super.key});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends MinionBaseWidgetState<ViewPage> {
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
    _currentMode = FlameMode(sendToOthers: _send);
    _currentMode.initMinion();
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
