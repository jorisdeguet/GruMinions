
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../service/gru_service.dart';
import '../base-mode.dart';
import '../flame.dart';
import '../synchro.dart';
import '../player/controller_character.dart';

class ChooseLevel extends StatefulWidget {
  const ChooseLevel({
    super.key,
    required this.character,
  });

  final String character;

  @override
  _ChooseLevelState createState() => _ChooseLevelState();
}

class _ChooseLevelState extends State<ChooseLevel> {
  final List<String> _levels = [
    '01', '02', '03', '04', '05', '06', '07', '08', '09', '10',
    '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
    '21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
  ];

  final List<String> _messages = [];
  late GruMinionMode _currentMode;

  @override
  void initState() {
    Get.put(GruService());
    GruService service = Get.find<GruService>();
    service.onReceive.listen((element) {
      _receive(element);
    });
    _currentMode = SyncMode(sendToOthers: _send);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SpriteButton.asset(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChooseCharacter(),
              ),
            );
          },
          label: const Text(''),
          path: 'Menu/Buttons/Back.png',
          pressedPath: 'Menu/Buttons/Back.png',
          width: 50,
          height: 50,
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StrokeText(
            text: 'Level',
            strokeColor: Colors.black,
            strokeWidth: 4,
            textStyle: GoogleFonts.pixelifySans(
              textStyle: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 6,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: _levels.map(_levelButton).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _levelButton(String level) {
    return
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: SpriteButton.asset(
          onPressed: () {
            changeMode(level);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => _currentMode.controllerWidget()
                )
            );
          },
          label: const Text(''),
          path: 'Menu/Levels/$level.png',
          pressedPath: 'Menu/Levels/$level.png',
          width: 40,
          height: 40,
        ),
      );
  }

  void changeMode(String m) {
    _currentMode = FlameMode(sendToOthers: _send);
    _send(m);
    _currentMode.initController();
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
