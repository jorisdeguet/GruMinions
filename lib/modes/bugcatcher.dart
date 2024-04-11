import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/bugcatcher/bugcatcher_mainmenu.dart';
import 'package:gru_minions/modes/bugcatcher/overlays/instructions.dart';

import 'bugcatcher/bugcatcher_game.dart';
import 'bugcatcher/bugcatcher_gru_game_page.dart';
import 'bugcatcher/bugcatcher_screen_page.dart';
import 'bugcatcher/helpers/bugcatcher_direction.dart';
import 'bugcatcher/bugcatcher_controller_a_page.dart';
import 'bugcatcher/overlays/game_over.dart';

class BugCatcherMode extends GruMinionMode {
  BugCatcherMode({required super.sendToOthers});

  late BugCatcherGame gameA = BugCatcherGame();
  late BugCatcherGame gameB = BugCatcherGame();

  @override
  Widget gruWidget() {
    return GruBugCatcherPage(
      send: sendToOthers,
    );
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    // change the direction for Minion game

    List<String> parts = s.split(',');
    String controllerId = parts[0];

    if (parts.length >= 2) {
      bool Pressed = false;
      if (parts[1].contains('Direction')) {
        Direction direction = Direction.values.firstWhere((e) =>
            parts[1].contains(e.name));
        if (controllerId == 'ControllerA') {
          gameA.onJoyPad1DirectionChanged(direction);
        }
      } else {
        if (parts[2] == 'true') {
          Pressed = true;
        }
        if (parts[2] == 'false') {
          Pressed = false;
        }

        if (controllerId == 'ControllerA') {
          if (parts[1] == 'ButtonA') {
            if(gameA.overlays.activeOverlays.isEmpty){
              gameA.onAButtonPressed(Pressed);
            } else if (gameA.overlays.activeOverlays.contains(Instructions.iD)){
              gameA.overlays.remove(Instructions.iD);
              gameA.interval.start();
              gameA.resumeEngine();
            }

          } else if (parts[1] == 'ButtonB') {
            if(gameA.overlays.activeOverlays.isEmpty){
              gameA.onBButtonPressed(Pressed);
            }
          }
        } else if (controllerId == 'ControllerB') {
          if (parts[1] == 'ButtonA') {
            if(gameB.overlays.activeOverlays.isEmpty){
              gameB.onAButtonPressed(Pressed);
            }
          } else if (parts[1] == 'ButtonB') {
            if(gameB.overlays.activeOverlays.isEmpty){
              gameB.onBButtonPressed(Pressed);
            }
          }
        }
      }
    }
  }

    @override
    void handleMessageAsScreen(String s) {}

    @override
    void initGru() {}

    @override
    void initMinion() {
    }

    @override
    Widget minionWidget(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Select Option'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.green, Colors.white],
            ),
          ),
          child: Row(
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/bugcatcher/images/BugCatcherMap.png',
                    scale: 0.6,
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      color: Colors.black,
                      child: const SizedBox(
                        width: 450,
                        height: 300,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'In this game you need to count the number of bugs that are of a certain type.\n\n '
                                'The Joy pad is used to move the camera. While the A and B buttons control the counter.\n\n '
                                'Good luck! Select your controllers to start the game.',
                            maxLines: 15,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0, bottom: 15.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ControllerABugCatcherPage(send: sendToOthers),
                          ),
                        );
                      },
                      child: const Text('Player A', style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 65.0, right: 15.0),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       fixedSize: const Size(150, 50),
                  //     ),
                  //     onPressed: () {
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //           builder: (_) =>
                  //               ControllerBBugCatcherPage(send: sendToOthers),
                  //         ),
                  //       );
                  //     },
                  //     child: const Text('Controller B' , style: TextStyle(color: Colors.black)),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    @override
    Widget screenWidget(BuildContext context) {
      return BugCatcherMainMenuPage(send: sendToOthers, gameA: gameA);
    }

    @override
    String name() => "BugCatcher";
  }
