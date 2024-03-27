import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';

import 'bugcatcher/bugcatcher_game.dart';
import 'bugcatcher/bugcatcher_gru_game_page.dart';
import 'bugcatcher/bugcatcher_screen_page.dart';
import 'bugcatcher/helpers/bugcatcher_direction.dart';
import 'bugcatcher/bugcatcher_controller_a_page.dart';

class MasterfulDivinerMode extends GruMinionMode {
  MasterfulDivinerMode({required super.sendToOthers});

  final BugCatcherGame _gameA = BugCatcherGame();
  final BugCatcherGame _gameB = BugCatcherGame();

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

    if(parts.length >= 2){
      bool Pressed = false;
      if(parts[1].contains('Direction')){
        Direction direction = Direction.values.firstWhere((e) => parts[1].contains(e.name));
        if (controllerId == 'ControllerA') {
          _gameA.onJoyPad1DirectionChanged(direction);
        }
      } else {
        if (parts[1] == 'true') {
          Pressed = true;
        }
        if (parts[1] == 'false') {
          Pressed = false;
        }

        if (controllerId == 'ControllerA') {
          _gameA.onAButtonPressed(Pressed);
        } else if (controllerId == 'ControllerB') {
          _gameB.onAButtonPressed(Pressed);
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
                    builder: (_) => ControllerABugCatcherPage(send: sendToOthers),
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
    return ScreenBugCatcherPage(gameA: _gameA);
  }

  @override
  String name() => "BugCatcher";
}
