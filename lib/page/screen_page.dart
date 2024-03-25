import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/list_of_modes.dart';
import 'package:gru_minions/service/screen_service.dart';
import 'package:gru_minions/widget/view_base_widget.dart';

import '../modes/base/base-mode.dart';

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends ViewBaseWidgetState<ScreenPage> {
  late final List<ScreenControllerOption> _options = listOfModes(_send);

  late ScreenControllerOption _currentOption = _options[0];

  @override
  void initState() {
    Get.put(ScreenService());
    super.initState();
    Get.find<ScreenService>().onReceive.listen((element) {
      _receive(element);
    });
  }

  @override
  Widget content(BuildContext context) {
    return _currentOption.screenWidget(context);
  }

  void changeMode(String option) {
    for (ScreenControllerOption o in _options) {
      if (option == o.name()) {
        _currentOption = o;
        _currentOption.screenWidget(context);
      }
    }
    setState(() {});
  }

  void _send(String m) {
    Get.find<ScreenService>().p2p.sendStringToSocket(m);
    setState(() {});
  }

  void _receive(String m) {
    try {
      changeMode(m);
      _currentOption.handleMessageAsMinion(m);
    } catch (e) {
      print("Minion got exception while handling message $m  $e");
      e.printError();
    }
    setState(() {});
  }
}