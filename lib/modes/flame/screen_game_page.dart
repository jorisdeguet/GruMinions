import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';
import 'helpers/joypad.dart';

class ScreenGamePage extends StatefulWidget {
  final MainGame game;

  const ScreenGamePage({super.key, required this.game});

  @override
  ScreenGameState createState() => ScreenGameState();
}

class ScreenGameState extends State<ScreenGamePage> {
  late MainGame game = widget.game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            GameWidget(game: game),
          ],
        ));
  }
}
