import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'bugcatcher_game.dart';
import 'overlays/game_over.dart';
import 'overlays/instructions.dart';

class ScreenBugCatcherPage extends StatefulWidget {
  final BugCatcherGame gameA;

  const ScreenBugCatcherPage({super.key, required this.gameA});

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
          child: GameWidget(game: game, overlayBuilderMap: {
            GameOver.iD: (BuildContext context, BugCatcherGame game) =>
                GameOver(game: game),
            Instructions.iD: (BuildContext context, BugCatcherGame game) =>
                Instructions(game: game),
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return theGameWidget(controllerAGame);
  }
}
