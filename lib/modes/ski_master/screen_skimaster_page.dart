import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gru_minions/modes/ski_master/game/game.dart';

class ScreenSkiMasterPage extends StatefulWidget {
  final SkiMasterGame game;

  const ScreenSkiMasterPage({super.key, required this.game});

  @override
  ScreenGameState createState() => ScreenGameState();
}

class ScreenGameState extends State<ScreenSkiMasterPage> {
  late SkiMasterGame game = widget.game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            GameWidget.controlled(gameFactory: SkiMasterGame.new),
          ],
        ));
  }
}
