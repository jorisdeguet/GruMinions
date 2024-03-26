import 'package:flutter/material.dart';
import 'package:gru_minions/options/home/controller_home.dart';

import '../base/base-mode.dart';
import '../flame/helpers/direction.dart';
import 'screen_home.dart';

// taken from https://github.com/flame-games/player_move
class HomeOption extends ScreenControllerOption {
  HomeOption({required super.sendToOthers});

  @override
  void initController() {}

  @override
  void initScreen() {}

  @override
  Widget controllerWidget() {
    return const ControllerHome();
  }

  @override
  Widget screenWidget(BuildContext context) {
    return const ScreenHome();
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
  String name() => "home_option";
}
