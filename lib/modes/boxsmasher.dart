import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/boxsmasher/controller_a_game_page.dart';
import 'package:gru_minions/modes/boxsmasher/gru_game_page.dart';

import 'boxsmasher/boxsmasher_game.dart';
import 'boxsmasher/controller_b_game_page.dart';
import 'boxsmasher/screen_boxsmasher_page.dart';

class BoxSmasherMode extends GruMinionMode {
  BoxSmasherMode({required super.sendOthersTCP,required super.sendOthersUDP});

  final BoxSmasherGame _gameA = BoxSmasherGame();
  final BoxSmasherGame _gameB = BoxSmasherGame();

  @override
  Widget gruWidget() {
    return GruBoxSmasherPage(
      send: sendOthersTCP,
    );
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    // change the direction for Minion game
    print(s);

    List<String> parts = s.split(',');
    String controllerId = parts[0];

    if(parts.length >= 2){
      bool Pressed = false;
      if (parts[1] == 'true') {
        Pressed = true;
      }
      if (parts[1] == 'false') {
        Pressed = false;
      }
      print("Controller: $controllerId, Pressed: $Pressed");


      if (controllerId == 'ControllerA') {
        _gameA.onAButtonPressed(Pressed);
      } else if (controllerId == 'ControllerB') {
        _gameB.onAButtonPressed(Pressed);
      } else {
        print("Unknown controller ID");
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
                    builder: (_) => ControllerABoxSmasherPage(send: sendOthersTCP),
                  ),
                );
              },
              child: Text('Controller A'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ControllerBBoxSmasherPage(send: sendOthersTCP),
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
