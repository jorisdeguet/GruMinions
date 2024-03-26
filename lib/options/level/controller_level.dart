import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';


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
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
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
          //set level
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
