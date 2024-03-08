import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gru_minions/modes/flame/helpers/a_button.dart';

import 'game.dart';
import 'helpers/b_button.dart';
import 'helpers/joypad.dart';

class ControllerBGamePage extends StatefulWidget {
  final Function send;

  const ControllerBGamePage({required this.send});

  @override
  ControllerBGameState createState() => ControllerBGameState();
}

class ControllerBGameState extends State<ControllerBGamePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Joypad(
                  onDirectionChanged: (direction) {
                    widget.send('ControllerB,' + direction.toString());
                  },
                ),
              ),
            ),

          ],
        ));
  }
}
