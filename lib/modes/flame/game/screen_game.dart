import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../helpers/life_bar.dart';
import '../helpers/score_bar.dart';
import '../helpers/time_bar.dart';
import '../overlays/end.dart';
import '../overlays/game_over.dart';
import '../overlays/menu.dart';
import 'pixel_adventure.dart';

class ScreenGame extends StatefulWidget {
  @override
  _ScreenGameState createState() => _ScreenGameState();

  const ScreenGame({required this.character, required this.level});

  final String character;
  final String level;
}

class _ScreenGameState extends State<ScreenGame> {
  late PixelAdventure game;
  late TimerBar timerBar;

  @override
  initState() {
    game = PixelAdventure(character: widget.character, level: widget.level);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LifeBar(life: game.player.life, game: game),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      //remove for game release
                      child: Column(
                        children: [
                          ScoreBar(score: game.score),
                          TimerBar(game: game, time: game.time),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GameWidget(
                game: game,
                overlayBuilderMap: {
                  'Menu': (BuildContext context, PixelAdventure game) {
                    return Menu(game: game);
                  },
                  'GameOver': (BuildContext context, PixelAdventure game) {
                    return GameOver(game: game);
                  },
                  'End': (BuildContext context, PixelAdventure game) {
                    return End(game: game);
                  },
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
