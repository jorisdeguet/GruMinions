import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/ski_master/helpers/skimaster_direction.dart';

import 'ski_master/controller_a_game_page.dart';
import 'ski_master/game/game.dart';
import 'ski_master/gru_game_page.dart';
import 'ski_master/screen_skimaster_page.dart';

class SkiMaster extends GruMinionMode {
  SkiMaster({required super.sendToOthers});

  final SkiMasterGame _game = SkiMasterGame();

  @override
  Widget gruWidget() {
    return GruSkiMasterPage(
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
      if(parts[1].contains('Direction')){
        Direction direction = Direction.values.firstWhere((e) => parts[1].contains(e.name));
        print("Handle message as Minion: $controllerId, $direction");
        if (controllerId == 'ControllerA') {
          print("Minion received controllerA $direction");
          _game.onJoyPad1DirectionChanged(direction);
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
                    builder: (_) => ControllerAGamePage(send: sendToOthers),
                  ),
                );
              },
              child: const Text('Controller A'),
            ),
            //ElevatedButton(
            //  onPressed: () {
            //    Navigator.of(context).push(
            //      MaterialPageRoute(
            //        builder: (_) => ControllerBGamePage(send: sendToOthers),
            //      ),
            //    );
            //  },
            //  child: const Text('Controller B'),
            //),
          ],
        ),
      ),
    );
  }

  @override
  Widget screenWidget(BuildContext context) {
    return ScreenSkiMasterPage(game: _game);
  }

  @override
  String name() => "SkiMaster";
}
