import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';

import 'bugcatcher/bugcatcher_game.dart';
import 'bugcatcher/bugcatcher_gru_game_page.dart';
import 'bugcatcher/bugcatcher_screen_page.dart';
import 'bugcatcher/helpers/bugcatcher_direction.dart';
import 'bugcatcher/bugcatcher_controller_a_page.dart';
import 'bugcatcher/overlays/game_over.dart';

class BugCatcherMode extends GruMinionMode {
  BugCatcherMode({required super.sendToOthers}) {
    gameA = BugCatcherGame();
    gameB = BugCatcherGame();
  }

  late BugCatcherGame gameA;
  late BugCatcherGame gameB;

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
    void initMinion() {}

    @override
    Widget minionWidget(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Select Option'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          ControllerABugCatcherPage(send: sendToOthers),
                    ),
                  );
                },
                child: const Text('Controller A'),
              ),
            ],
          ),
        ),
      );
    }

    @override
    Widget screenWidget(BuildContext context) {
      return ScreenBugCatcherPage(gameA: gameA);
    }

    @override
    String name() => "BugCatcher";
  }
