import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/modes/flame.dart';
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
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 20,
              children: _modes.map(_buttonForLevel).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonForLevel(GruMinionMode e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            const Image(
              image: AssetImage('assets/images/Background/Level.png'),
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      e.name(),
                      style: GoogleFonts.pixelifySans(
                        textStyle: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'subtitle',
                      style: GoogleFonts.pixelifySans(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Image(
                        width: 32,
                        height: 32,
                        image: AssetImage('assets/images/Main Characters/Mask Dude/Jump (32x32).png')
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      color: Colors.white,
                      onPressed: () {
                        changeMode(e.name());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => _currentMode.gruWidget()
                            )
                        );
                      },
                      child: Text(
                        'Start',
                        style: GoogleFonts.pixelifySans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  void changeMode(String m) {
    _currentMode = FlameMode(sendToOthers: _send);
    _send(m);
    _currentMode.initGru();
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
