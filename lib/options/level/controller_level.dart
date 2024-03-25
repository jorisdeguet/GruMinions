import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

import '../character/controller_character.dart';

class ControllerLevel extends StatefulWidget {
  const ControllerLevel({
    super.key,
    required this.character,
  });

  final String character;

  @override
  State<ControllerLevel> createState() => _ControllerLevelState();
}

class _ControllerLevelState extends State<ControllerLevel> {
  final List<String> _levels = [
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SpriteButton.asset(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ControllerCharacter(),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SpriteButton.asset(
        onPressed: () {
          //changeMode(level);
        },
        label: const Text(''),
        path: 'Menu/Levels/$level.png',
        pressedPath: 'Menu/Levels/$level.png',
        width: 40,
        height: 40,
      ),
    );
  }
}
