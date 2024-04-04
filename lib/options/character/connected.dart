import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Connected extends StatefulWidget {
  final ValueNotifier<String> characterPlayer2;

  const Connected({super.key, required this.characterPlayer2});

  @override
  State<Connected> createState() => _ConnectedState();
}

class _ConnectedState extends State<Connected> {
  // @override
  // void initState() {
  //   widget.characterPlayer2.value = 'Mask Dude';
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.characterPlayer2,
      builder: (context, score, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Player 2 : ${widget.characterPlayer2.value}',
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black54,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: SpriteAnimationWidget.asset(
                              path:
                              "Main Characters/${widget.characterPlayer2.value}/Idle (32x32).png",
                              //running
                              data: SpriteAnimationData.sequenced(
                                amount: 11,
                                stepTime: 0.05,
                                textureSize: Vector2(32, 32),
                                loop: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black45,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: SpriteAnimationWidget.asset(
                              path:
                              "Main Characters/${widget.characterPlayer2.value}/Run (32x32).png",
                              data: SpriteAnimationData.sequenced(
                                amount: 12,
                                stepTime: 0.05,
                                textureSize: Vector2(32, 32),
                                loop: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black26,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: SpriteAnimationWidget.asset(
                              path:
                              "Main Characters/${widget.characterPlayer2.value}/Wall Jump (32x32).png",
                              data: SpriteAnimationData.sequenced(
                                amount: 5,
                                stepTime: 0.05,
                                textureSize: Vector2(32, 32),
                                loop: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: SpriteAnimationWidget.asset(
                              path:
                              "Main Characters/${widget.characterPlayer2.value}/Hit (32x32).png",
                              data: SpriteAnimationData.sequenced(
                                amount: 7,
                                stepTime: 0.05,
                                textureSize: Vector2(32, 32),
                                loop: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}