import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'boxsmasher_game.dart';
import 'overlays/lose.dart';
import 'overlays/win.dart';

class ScreenBoxSmasherPage extends StatefulWidget {
  final BoxSmasherGame gameA;
  final Function send;
  final BoxSmasherGame gameB;

  const ScreenBoxSmasherPage({super.key, required this.gameA, required this.gameB, required this.send});

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
          child:GameWidget(
            game: game,
            overlayBuilderMap: {
              Win.iD: (BuildContext context, BoxSmasherGame game) => Win(game: game),
              Lose.iD: (BuildContext context, BoxSmasherGame game) => Lose(game: game),
            }
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Center(
          child: Row(
            children: [
              Expanded(
                child: theGameWidget(controllerAGame),
              ),
              Expanded(
                child: theGameWidget(controllerBGame),
              ),
            ],
          ),
        ));
  }
}
