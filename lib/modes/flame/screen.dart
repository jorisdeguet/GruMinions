import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game.dart';

class Screen extends StatefulWidget {
  const Screen({super.key, required this.game});
  final MainGame game;

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<Screen> {
  late MainGame game = widget.game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: GameWidget(game: game)
    );
  }
}
