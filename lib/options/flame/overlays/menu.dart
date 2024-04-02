import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';

import '../game/pixel_adventure.dart';

class Menu extends StatelessWidget {
  final PixelAdventure game;
  const Menu({super.key, required this.game});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 500,
          width: 700,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StrokeText(
                text: 'Menu',
                strokeColor: Colors.black,
                strokeWidth: 4,
                textStyle: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              StrokeText(
                text: 'Game on pause!',
                strokeColor: Colors.black,
                strokeWidth: 4,
                textStyle: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: SpriteAnimationWidget.asset(
                  path: "/Main Characters/${game.character}/Idle (32x32).png",
                  data: SpriteAnimationData.sequenced(
                    amount: 11,
                    stepTime: 0.05,
                    textureSize: Vector2.all(32),
                    loop: true,
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 5,
                indent: 20,
                endIndent: 20,
                color: Colors.black,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      StrokeText(
                        text: 'Life :',
                        strokeColor: Colors.black,
                        strokeWidth: 4,
                        textStyle: GoogleFonts.pixelifySans(
                          textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      StrokeText(
                        text: (game.player.life.value.toInt()).toString(),
                        strokeColor: Colors.black,
                        strokeWidth: 4,
                        textStyle: GoogleFonts.pixelifySans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      StrokeText(
                        text: 'Score :',
                        strokeColor: Colors.black,
                        strokeWidth: 4,
                        textStyle: GoogleFonts.pixelifySans(
                          textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      StrokeText(
                        text: game.score.value.toString(),
                        strokeColor: Colors.black,
                        strokeWidth: 4,
                        textStyle: GoogleFonts.pixelifySans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      StrokeText(
                        text: 'Time :',
                        strokeColor: Colors.black,
                        strokeWidth: 4,
                        textStyle: GoogleFonts.pixelifySans(
                          textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      StrokeText(
                        text: _formatDuration(Duration(seconds: game.time.value)),
                        strokeColor: Colors.black,
                        strokeWidth: 4,
                        textStyle: GoogleFonts.pixelifySans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpriteButton.asset(
                    onPressed: () {
                      game.resumeEngine();
                      game.overlays.remove('Menu');
                    },
                    label: const Text(''),
                    path: '/Menu/Buttons/Play.png',
                    pressedPath: '/Menu/Buttons/Play.png',
                    width: 50,
                    height: 50,
                  ),
                  SpriteButton.asset(
                    onPressed: () {
                      game.resumeEngine();
                      game.restartLevel();
                    },
                    label: const Text(''),
                    path: '/Menu/Buttons/Restart.png',
                    pressedPath: '/Menu/Buttons/Restart.png',
                    width: 50,
                    height: 50,
                  ),
                  SpriteButton.asset(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => ControllerLevel(character: game.character)
                      //   ),
                      // );
                    },
                    label: const Text(''),
                    path: '/Menu/Buttons/Levels.png',
                    pressedPath: '/Menu/Buttons/Levels.png',
                    width: 50,
                    height: 50,
                  ),
                  SpriteButton.asset(
                    onPressed: () {
                      game.playSounds = !game.playSounds;
                    },
                    label: const Text(''),
                    path: '/Menu/Buttons/Volume.png',
                    pressedPath: '/Menu/Buttons/Volume.png',
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
