import 'dart:core';

import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenCharacter extends StatefulWidget {
  final ValueNotifier<String> characterName;

  const ScreenCharacter({super.key, required this.characterName});

  @override
  State<ScreenCharacter> createState() => _ScreenCharacterState();
}

class _ScreenCharacterState extends State<ScreenCharacter> {
  @override
  void initState() {
    widget.characterName.value = 'Mask Dude';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.characterName,
      builder: (context, score, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Player 1 : ${widget.characterName.value}',
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
                                  "Main Characters/${widget.characterName.value}/Idle (32x32).png",
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
                                  "Main Characters/${widget.characterName.value}/Run (32x32).png",
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
                                  "Main Characters/${widget.characterName.value}/Wall Jump (32x32).png",
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
                                  "Main Characters/${widget.characterName.value}/Hit (32x32).png",
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
              const SizedBox(height: 20),
              Text(
                'Player 2 : none',
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
                  Text(
                    'Waiting for Player 2...',
                    style: GoogleFonts.pixelifySans(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
