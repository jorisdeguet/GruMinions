import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'bugcatcher_game.dart';
import 'overlays/game_over.dart';

class ScreenBugCatcherPage extends StatefulWidget {
  final BugCatcherGame gameA;

  const ScreenBugCatcherPage(
      {super.key, required this.gameA});

  @override
  ScreenBugCatcherState createState() => ScreenBugCatcherState();
}

class ScreenBugCatcherState extends State<ScreenBugCatcherPage> {
  late BugCatcherGame controllerAGame = widget.gameA;

  Widget theGameWidget(BugCatcherGame game) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: GameWidget(
              game: game,
              overlayBuilderMap: {
                'GameOver': (BuildContext context, BugCatcherGame game) =>
                    GameOver(game: game),
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
        body: Row(
          children: [
            Expanded(
              child: theGameWidget(controllerAGame),
            ),
          ],
        )
    );
  }
}
