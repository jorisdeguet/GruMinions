
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/service/controller_service.dart';
import 'package:gru_minions/widget/controller_base_widget.dart';
import 'package:sidebarx/sidebarx.dart';

import '../modes/base/base-mode.dart';
import '../modes/character/character_mode.dart';
import '../modes/list_of_modes.dart';

class Controller extends StatefulWidget {
  const Controller({super.key});

  @override
  State<Controller> createState() => _MainBossPageState();
}

class _MainBossPageState extends ControllerBaseWidgetState<Controller> {
  final List<String> _messages = [];
  late final List<ScreenControllerOption> _modes = listOfModes(_send);
  late ScreenControllerOption _currentMode;

  @override
  void initState() {
    Get.put(ControllerService());
    ControllerService service = Get.find<ControllerService>();
    service.onReceive.listen((element) {
      _receive(element);
    });
    _currentMode = CharacterMode(sendToOthers: _send);
    _currentMode.initController();
    super.initState();
  }

  @override
  Widget content(BuildContext context) {
    return Scaffold(
      drawer: SidebarX(
        controller: SidebarXController(selectedIndex: 0),
        theme: SidebarXTheme(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          hoverColor: Colors.black.withOpacity(0.2),
          textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          selectedTextStyle: const TextStyle(color: Colors.white),
          itemTextPadding: const EdgeInsets.only(left: 30),
          selectedItemTextPadding: const EdgeInsets.only(left: 30),
          itemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
          ),
          selectedItemDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black.withOpacity(0.37),
            ),
            gradient: const LinearGradient(
              colors: [Colors.black38, Colors.black],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 30,
              )
            ],
          ),
          iconTheme: IconThemeData(
            color: Colors.white.withOpacity(0.7),
            size: 20,
          ),
          selectedIconTheme: const IconThemeData(
            color: Colors.white,
            size: 20,
          ),
        ),
        extendedTheme: const SidebarXTheme(
          width: 200,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        headerBuilder: (context, extended) {
          return SizedBox(
            width: 100,
            height: 100,
            child: SpriteAnimationWidget.asset(
              path: "assets/images/Main Characters/Mask Dude/Idle (32x32).png",
              data: SpriteAnimationData.sequenced(
                amount: 11,
                stepTime: 0.05,
                textureSize: Vector2(32, 32),
                loop: true,
              ),
            ),
          );
        },
        items: [
          SidebarXItem(
            icon: Icons.play_arrow_rounded,
            label: 'Start Game',
            onTap: () {
              changeMode("flame");
            },
          ),
          SidebarXItem(
            icon: Icons.settings_accessibility,
            label: 'Choose Character',
            onTap: () {
              changeMode("character_mode");
            },
          ),
          SidebarXItem(
            icon: Icons.map,
            label: 'Choose Level',
            onTap: () {
              changeMode("level_mode");
            },
          ),
          const SidebarXItem(
            icon: Icons.settings,
            label: 'Settings',
          ),
          const SidebarXItem(
            iconWidget: FlutterLogo(size: 20),
            label: 'Flutter',
          ),
        ],
        footerDivider: Divider(
          color: Colors.white.withOpacity(0.5),
          thickness: 0.5,
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _currentMode.controllerWidget()), // Your app screen body
        ],
      ),
    );
  }

  void changeMode(String option) {
    for (ScreenControllerOption mode in _modes) {
      if (option == mode.name()) {
        _currentMode = mode;
      }
    }
    _send(option);
    _currentMode.initController();
    setState(() {});
  }

  void _send(String m) {
    _messages.insert(0, "Gru - $m");
    Get.find<ControllerService>().p2p.sendStringToSocket(m);
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