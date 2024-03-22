
import 'package:flutter/material.dart';
import 'package:gru_minions/modes/masterfuldiviner/masterfuldiviner_game.dart';

import 'base-mode.dart';
import 'masterfuldiviner/masterfuldiviner_gru_game_page.dart';
import 'masterfuldiviner/masterfuldiviner_controller_a_page.dart';
import 'masterfuldiviner/masterfuldiviner_screen_page.dart';

class MasterfulDivinerMode extends GruMinionMode {
  MasterfulDivinerMode({required super.sendToOthers});

  final MasterfulDivinerGame _gameA = MasterfulDivinerGame();
  final MasterfulDivinerGame _gameB = MasterfulDivinerGame();

  @override
  Widget gruWidget() {
    return GruMasterfulDivinerPage(
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
                    builder: (_) => ControllerAMasterfulDivinerPage(send: sendToOthers),
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
    return ScreenMasterfulDivinerPage(gameA: _gameA);
  }

  @override
  String name() => "MasterfulDiviner";
}
