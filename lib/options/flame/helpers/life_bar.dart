import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/pixel_adventure.dart';

class LifeBar extends StatelessWidget {
  final PixelAdventure game;

  const LifeBar({
    super.key,
    required this.game,
  });

  Color getPlayerLifeColor() {
    if (game.player.life.value >= 2) {
      return Colors.white;
    }else {
      return Colors.red;
    }
  }

  Color getFriendLifeColor() {
    if (game.friend!.life.value >= 2) {
      return Colors.white;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
        valueListenable: game.player.life,
        builder: (context, score, child) {
          return Row(
            children: [
              InkWell(
                onTap: () {
                  game.pauseEngine();
                  game.overlays.add('Menu');
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SpriteAnimationWidget.asset(
                    path: 'Menu/Buttons/Settings.png',
                    //running
                    data: SpriteAnimationData.sequenced(
                      amount: 1,
                      stepTime: 1,
                      textureSize: Vector2(21, 22),
                      loop: true,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SpriteAnimationWidget.asset(
                      path:
                          'Main Characters/${game.playerName}/Idle (32x32).png',
                      //running
                      data: SpriteAnimationData.sequenced(
                        amount: 11,
                        stepTime: 0.05,
                        textureSize: Vector2(32, 32),
                        loop: true,
                      ),
                    ),
                  ),
                  Text(
                    'X ${game.player.life.value.toInt()}',
                    style: GoogleFonts.pixelifySans(
                      color: getPlayerLifeColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
              game.friendName != null
                  ? ValueListenableBuilder<double>(
                      valueListenable: game.friend!.life,
                      builder: (context, score, child) {
                        return Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SpriteAnimationWidget.asset(
                                path:
                                    'Main Characters/${game.friendName}/Idle (32x32).png',
                                //running
                                data: SpriteAnimationData.sequenced(
                                  amount: 11,
                                  stepTime: 0.05,
                                  textureSize: Vector2(32, 32),
                                  loop: true,
                                ),
                              ),
                            ),
                            Text(
                              'X ${game.friend!.life.value.toInt()}',
                              style: GoogleFonts.pixelifySans(
                                color: getFriendLifeColor(),
                                fontSize: 20,
                                fontWeight: FontWeight.w200,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : Container(),
            ],
          );
        });
  }
}
