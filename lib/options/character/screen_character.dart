import 'dart:core';

import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/comm/message.dart';
import 'package:gru_minions/options/character/waiting_character.dart';

class ScreenCharacter extends StatefulWidget {
  final ValueNotifier<String> characterPlayer1;
  final ValueNotifier<String> characterPlayer2;

  const ScreenCharacter(
      {super.key,
      required this.characterPlayer1,
      required this.characterPlayer2});

  @override
  State<ScreenCharacter> createState() => _ScreenCharacterState();
}

class _ScreenCharacterState extends State<ScreenCharacter> {
  @override
  void initState() {
    //will set the current character for the players
    //normally player 1 is always set, no need to verify
    widget.characterPlayer1.value = currentConfig.characterPlayer1;

    //check if player 2 is null
    if(currentConfig.characterPlayer2 == null){
      //if it is null, set the value to an empty string
      widget.characterPlayer2.value = '';
    } else {
      //else, set the value to the current character
      widget.characterPlayer2.value = currentConfig.characterPlayer2!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.characterPlayer1,
      builder: (context, score, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Player 1 : ${widget.characterPlayer1.value}',
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
                                  "Main Characters/${widget.characterPlayer1.value}/Idle (32x32).png",
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
                                  "Main Characters/${widget.characterPlayer1.value}/Run (32x32).png",
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
                                  "Main Characters/${widget.characterPlayer1.value}/Wall Jump (32x32).png",
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
                                  "Main Characters/${widget.characterPlayer1.value}/Hit (32x32).png",
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
              ValueListenableBuilder<String>(
                valueListenable: widget.characterPlayer2,
                builder: (context, score, child) {
                  return widget.characterPlayer2.value.isEmpty
                      ? const WaitingCharacter()
                      : Center(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: SpriteAnimationWidget.asset(
                                              path:
                                                  "Main Characters/${widget.characterPlayer2.value}/Idle (32x32).png",
                                              //running
                                              data:
                                                  SpriteAnimationData.sequenced(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: SpriteAnimationWidget.asset(
                                              path:
                                                  "Main Characters/${widget.characterPlayer2.value}/Run (32x32).png",
                                              data:
                                                  SpriteAnimationData.sequenced(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: SpriteAnimationWidget.asset(
                                              path:
                                                  "Main Characters/${widget.characterPlayer2.value}/Wall Jump (32x32).png",
                                              data:
                                                  SpriteAnimationData.sequenced(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: SpriteAnimationWidget.asset(
                                              path:
                                                  "Main Characters/${widget.characterPlayer2.value}/Hit (32x32).png",
                                              data:
                                                  SpriteAnimationData.sequenced(
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
              ),
            ],
          ),
        );
      },
    );
  }
}
