import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/flame/game.dart';
import 'package:gru_minions/modes/flame/gru_game_page.dart';
import 'package:gru_minions/modes/flame/helpers/direction.dart';
import 'package:gru_minions/modes/flame/main_game_page.dart';

// taken from https://github.com/flame-games/player_move
class FlameMode extends GruMinionMode {
  FlameMode({required super.sendToOthers});

  MainGame game = MainGame();

  late Function setMinionDirection;

  @override
  Widget gruWidget() {
    return GruGamePage(send: sendToOthers,);
  }

  @override
  void handleMessageAsGru(String s) {

  }

  @override
  void handleMessageAsMinion(String s) {
    // change the direction for Minion game
    print(s);

    Direction d = Direction.values.firstWhere((e) => s.contains(e.name));
    print("Good  " + d.toString());
    game.onJoyPad2DirectionChanged(d);
  }

  @override
  void initGru() {

  }

  @override
  void initMinion() {

  }

  @override
  Widget minionWidget(BuildContext context) {
    return MainGamePage(game : game);
  }

  @override
  String name() => "flame";

}