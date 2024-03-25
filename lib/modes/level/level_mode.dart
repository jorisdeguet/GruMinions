import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base/base-mode.dart';
import 'package:gru_minions/modes/level/view_level.dart';
import 'package:gru_minions/modes/level/controller_level.dart';
import 'package:gru_minions/modes/flame/helpers/direction.dart';


// taken from https://github.com/flame-games/player_move
class LevelMode extends ScreenControllerOption {
  LevelMode({required super.sendToOthers});

  @override
  void initController() {}

  @override
  void initScreen() {}

  @override
  Widget controllerWidget() {
    return const ControllerLevel(character: "Virtual Guy");
  }

  @override
  Widget screenWidget(BuildContext context) {
    return const ViewLevel(character: "Virtual Guy");
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    // change the direction for Minion game
    print(s);

    Direction d = Direction.values.firstWhere((e) => s.contains(e.name));
    print("Good  $d");
    //_game.onJoyPad1DirectionChanged(d);
  }

  @override
  String name() => "level_mode";
}
