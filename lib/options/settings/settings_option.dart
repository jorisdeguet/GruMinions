
import 'package:flutter/material.dart';

import '../base/base-mode.dart';
import '../flame/helpers/direction.dart';

// taken from https://github.com/flame-games/player_move
class SettingsOption extends ScreenControllerOption {
  SettingsOption({required super.sendToOthers});

  @override
  void initController() {}

  @override
  void initScreen() {}

  @override
  Widget controllerWidget() {
    return const Text('data');
  }

  @override
  Widget screenWidget(BuildContext context) {
    return const Text('data');
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
  String name() => "level_mode";
}

