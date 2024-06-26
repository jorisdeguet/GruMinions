import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'helpers/joypad.dart';

class MainGamePage extends StatefulWidget {
  final MainGame game;

  const MainGamePage({super.key, required this.game});

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGamePage> {
  late MainGame game = widget.game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            GameWidget(game: game),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child:
                    Joypad(onDirectionChanged: game.onJoyPad1DirectionChanged),
              ),
            ),
          ],
        ));
  }
}
