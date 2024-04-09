import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/comm/message.dart';
import 'package:gru_minions/service/screen_service.dart';
import 'package:gru_minions/widget/screen_base_widget.dart';

import '../options/base/base-mode.dart';
import '../options/list_of_modes.dart';

class ScreenPage extends StatefulWidget {
  const ScreenPage({super.key});

  @override
  State<ScreenPage> createState() => _ScreenPageState();
}

class _ScreenPageState extends ScreenBaseWidgetState<ScreenPage> {
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

  void _send(String option) {
    Get.find<ScreenService>().p2p.sendStringToSocket(option);
    setState(() {});
  }

  void _receive(String option) {
    try {
      changeMode(option);
      _currentOption.handleMessageAsMinion(option);
    } catch (e) {
      if (kDebugMode) {
        print("Minion got exception while handling message $option  $e");
      }
      e.printError();
    }
    setState(() {});
  }
}
