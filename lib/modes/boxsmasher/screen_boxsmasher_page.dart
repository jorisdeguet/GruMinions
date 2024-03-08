import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'boxsmasher_game.dart';

class ScreenBoxSmasherPage extends StatefulWidget {
  final BoxSmasherGame game;

  const ScreenBoxSmasherPage({super.key, required this.game});

  @override
  ScreenBoxSmasherState createState() => ScreenBoxSmasherState();
}

class ScreenBoxSmasherState extends State<ScreenBoxSmasherPage> {
  late BoxSmasherGame game = widget.game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child:GameWidget(game: game),
            ),
          ],
        ));
  }
}
