import 'dart:core';

import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/comm/message.dart';
import 'package:gru_minions/options/character/waiting_character.dart';

class ScreenCharacter extends StatefulWidget {
  final ValueNotifier<String> playerName;
  final ValueNotifier<String> friendName;

  const ScreenCharacter(
      {super.key,
      required this.playerName,
      required this.friendName});

  @override
  State<ScreenCharacter> createState() => _ScreenCharacterState();
}

class _ScreenCharacterState extends State<ScreenCharacter> {
  @override
  void initState() {
    //set the current character for each player
    //player 1 is never null so no need to verify
    widget.playerName.value = currentConfig.playerName;

    //player 2 is optional
    //check if player 2 is null
    if (currentConfig.friendName == null) {
      //set value to an empty string
      widget.friendName.value = '';
    } else {
      //set value to the default character
      widget.friendName.value = currentConfig.friendName!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.playerName,
      builder: (context, score, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Player 1 : ${widget.playerName.value}',
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
                                  "Main Characters/${widget.playerName.value}/Idle (32x32).png",
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
                                  "Main Characters/${widget.playerName.value}/Run (32x32).png",
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
                                  "Main Characters/${widget.playerName.value}/Wall Jump (32x32).png",
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
                                  "Main Characters/${widget.playerName.value}/Hit (32x32).png",
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
                valueListenable: widget.friendName,
                builder: (context, score, child) {
                  return widget.friendName.value.isEmpty
                      ? const WaitingCharacter()
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Player 2 : ${widget.friendName.value}',
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
                                                  "Main Characters/${widget.friendName.value}/Idle (32x32).png",
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
                                                  "Main Characters/${widget.friendName.value}/Run (32x32).png",
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
                                                  "Main Characters/${widget.friendName.value}/Wall Jump (32x32).png",
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
                                                  "Main Characters/${widget.friendName.value}/Hit (32x32).png",
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
