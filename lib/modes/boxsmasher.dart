import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/boxsmasher/controller_a_game_page.dart';
import 'package:gru_minions/modes/boxsmasher/gru_game_page.dart';

import 'boxsmasher/boxsmasher_game.dart';
import 'boxsmasher/controller_b_game_page.dart';
import 'boxsmasher/helpers/direction.dart';
import 'boxsmasher/screen_boxsmasher_page.dart';

class BoxSmasherMode extends GruMinionMode {
  BoxSmasherMode({required super.sendToOthers});

  final BoxSmasherGame _gameA = BoxSmasherGame();
  final BoxSmasherGame _gameB = BoxSmasherGame();

  @override
  Widget gruWidget() {
    return GruBoxSmasherPage(
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
          // In Case of Joystick
          // _gameA.onJoyPad1DirectionChanged(direction);
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
            if(_gameA.overlays.activeOverlays.isEmpty){
              _gameA.onAButtonPressed(Pressed);
            }

          } else if (parts[1] == 'ButtonB') {
            if(_gameA.overlays.activeOverlays.isEmpty){
              //In Case of Button B
              // _gameA.onBButtonPressed(Pressed);
            }
          }
        } else if (controllerId == 'ControllerB') {
          if (parts[1] == 'ButtonA') {
            if(_gameB.overlays.activeOverlays.isEmpty){
              _gameB.onAButtonPressed(Pressed);
            }
          } else if (parts[1] == 'ButtonB') {
            if(_gameB.overlays.activeOverlays.isEmpty){
              //In Case of Button B
              // _gameB.onBButtonPressed(Pressed);
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
        title: Text('Select Option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('In this game you need to press the A button as fast as you can to win.'),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ControllerABoxSmasherPage(send: sendToOthers),
                  ),
                );
              },
              child: Text('Controller A'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ControllerBBoxSmasherPage(send: sendToOthers),
                  ),
                );
              },
              child: Text('Controller b'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget screenWidget(BuildContext context) {
    return ScreenBoxSmasherPage(gameA: _gameA, gameB: _gameB);
  }

  @override
  String name() => "BoxSmasher";
}
