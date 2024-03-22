import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/game.dart';

void main() {
  runApp(const SkiMasterApp());
}

class SkiMasterApp extends StatelessWidget {
  const SkiMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    //No complex widget setup required so no scaffold needed
    return const MaterialApp(
      //To avoid managing an Instance of Flame we use the dart controlled ctor
      //otherwise with the normal ctor we would have needed to store the game instance outside the build instance
      //this ctor need a gameFactory callback to invoke new instance of the game
      //the SkiMasterGame.new is as good as writing a anonymous function that return new instance
      home: GameWidget.controlled(gameFactory: SkiMasterGame.new),
    );
  }
}
