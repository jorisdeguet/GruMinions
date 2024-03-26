import 'package:flutter/material.dart';

import '../base/base-mode.dart';
import '../flame/helpers/direction.dart';
import 'controller_level.dart';
import 'screen_level.dart';

// taken from https://github.com/flame-games/player_move
class LevelOption extends ScreenControllerOption {
  LevelOption({required super.sendToOthers});

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
    return const ScreenLevel(character: "Virtual Guy");
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    // change the direction for Minion game
    Direction d = Direction.values.firstWhere((e) => s.contains(e.name));
    //_game.onJoyPad1DirectionChanged(d);
  }

  @override
  String name() => "level_option";
}
