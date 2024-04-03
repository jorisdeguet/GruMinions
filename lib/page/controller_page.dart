import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/options/home/home_option.dart';
import 'package:gru_minions/service/controller_service.dart';
import 'package:gru_minions/widget/controller_base_widget.dart';
import 'package:sidebarx/sidebarx.dart';

import '../options/base/base-mode.dart';
import '../options/list_of_modes.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({super.key});

  @override
  State<ControllerPage> createState() => _MainBossPageState();
}

class _MainBossPageState extends ControllerBaseWidgetState<ControllerPage> {
  final List<String> _messages = [];
  late final List<ScreenControllerOption> _options = listOfModes(_send);
  late ScreenControllerOption _currentOption;
  late int? id;

  @override
  void initState() {
    Get.put(ControllerService());
    ControllerService service = Get.find<ControllerService>();
    service.onReceive.listen((element) {
      _receive(element);
    });
    _currentOption = HomeOption(sendToOthers: _send);

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
          return const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: ClipOval(
                child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("assets/icons/profile.png"),
            )),
          );
        },
        items: [
          SidebarXItem(
            icon: Icons.home_rounded,
            label: 'Home',
            onTap: () {
              changeMode("home_option");
            },
          ),
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
              changeMode("character_option");
            },
          ),
          SidebarXItem(
            icon: Icons.map,
            label: 'Choose Level',
            onTap: () {
              changeMode("level_option");
            },
          ),
          SidebarXItem(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () {
              changeMode("settings_option");
            },
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
          Expanded(child: _currentOption.controllerWidget()),
          // Your app screen body
        ],
      ),
    );
  }

  void changeMode(String option) {
    for (ScreenControllerOption mode in _options) {
      if (option == mode.name()) {
        _currentOption = mode;
      }
    }
    _send(option);
    setState(() {});
  }

  void _send(String option) {
    _messages.insert(0, "Controller - $option");
    Get.find<ControllerService>().p2p.sendStringToSocket(option);
    setState(() {});
  }

  void _receive(String option) {
    try {
      changeMode(option);
      _messages.insert(0, "Screen - $option");
      _currentOption.handleMessageAsGru(option);
    } catch (e) {
      if (kDebugMode) {
        print("Screen got exception while handling message $option");
      }
      e.printError();
    }
    setState(() {});
  }
}
