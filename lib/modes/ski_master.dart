import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';

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
    print(s);

    List<String> parts = s.split(',');
    String controllerId = parts[0];

    //Direction direction =
    //    Direction.values.firstWhere((e) => s.contains(e.name));
    //print("Controller: $controllerId, Direction: $direction");
//
    //if (controllerId == 'ControllerA') {
    //  _game.onJoyPad1DirectionChanged(direction);
    //}
    //else if (controllerId == 'ControllerB') {
    //  _game.onJoyPad2DirectionChanged(direction);
    //} else {
    //  print("Unknown controller ID");
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
