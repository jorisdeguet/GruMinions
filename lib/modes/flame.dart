import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/flame/game.dart';
import 'package:gru_minions/modes/flame/gru_game_page.dart';
import 'package:gru_minions/modes/flame/helpers/direction.dart';
import 'package:gru_minions/modes/flame/controller_a_game_page.dart';

import 'flame/controller_b_game_page.dart';
import 'flame/screen_game_page.dart';

// taken from https://github.com/flame-games/player_move
class FlameMode extends GruMinionMode {
  FlameMode({required super.sendToOthers});

  final MainGame _game = MainGame();

  late Function _setMinionDirection;

  @override
  Widget gruWidget() {
    return GruGamePage(
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

    Direction direction = Direction.values.firstWhere((e) => s.contains(e.name));
    print("Controller: $controllerId, Direction: $direction");


    if (controllerId == 'ControllerA') {
      _game.onJoyPad1DirectionChanged(direction);
    } else if (controllerId == 'ControllerB') {
      _game.onJoyPad2DirectionChanged(direction);
    } else {
      print("Unknown controller ID");
    }
  }

  @override
  void handleMessageAsScreen(String s) {

  }

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
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ControllerAGamePage(send: sendToOthers),
                ),
              );
            },
            child: Text('Controller A'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ControllerBGamePage(send: sendToOthers),
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
    return ScreenGamePage(game: _game);
  }

  @override
  String name() => "flame";
}
