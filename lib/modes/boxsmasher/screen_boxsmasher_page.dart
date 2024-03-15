import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'boxsmasher_game.dart';

class ScreenBoxSmasherPage extends StatefulWidget {
  final BoxSmasherGame gameA;
  final BoxSmasherGame gameB;

  const ScreenBoxSmasherPage({super.key, required this.gameA, required this.gameB});

  @override
  ScreenBoxSmasherState createState() => ScreenBoxSmasherState();
}

class ScreenBoxSmasherState extends State<ScreenBoxSmasherPage> {
  late BoxSmasherGame controllerAGame = widget.gameA;
  late BoxSmasherGame controllerBGame = widget.gameB;


  Widget theGameWidget(BoxSmasherGame game) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child:GameWidget(game: game),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'Score: ${game.score}',
              style: const TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: Colors.black,
                    offset: Offset(0.0, 0.0),
                  ),
                ],
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Row(
          children: [
            Expanded(
              child: theGameWidget(controllerAGame),
            ),
            Expanded(
              child: theGameWidget(controllerBGame),
            ),
          ],
        ));
  }
}
