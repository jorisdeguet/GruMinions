import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'helpers/life_bar.dart';
import 'helpers/score_bar.dart';
import 'helpers/time_bar.dart';
import 'overlays/end.dart';
import 'overlays/game_over.dart';
import 'overlays/menu.dart';
import 'game/pixel_adventure.dart';

class ScreenGame extends StatefulWidget {
  @override
  State<ScreenGame> createState() => _ScreenGameState();

  const ScreenGame({super.key, required this.game});

  final PixelAdventure game;
}

class _ScreenGameState extends State<ScreenGame> {
  late TimerBar timerBar;

  @override
  initState() {
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
                    LifeBar(life: widget.game.player1.life, game: widget.game),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      //remove for game release
                      child: Column(
                        children: [
                          ScoreBar(score: widget.game.score),
                          TimerBar(game: widget.game, time: widget.game.time),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GameWidget(
                game: widget.game,
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
