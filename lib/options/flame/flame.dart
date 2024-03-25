import 'package:flutter/material.dart';

import '../base/base-mode.dart';
import 'controller.dart';
import 'game/pixel_adventure.dart';
import 'helpers/direction.dart';
import 'screen.dart';

// taken from https://github.com/flame-games/player_move
class FlameMode extends ScreenControllerOption {
  FlameMode({required super.sendToOthers});

  @override
  void initController() {}

  @override
  void initScreen() {}

  @override
  Widget controllerWidget() {
    return Controller(
      send: sendToOthers,
    );
  }

  @override
  Widget screenWidget(BuildContext context) {
    return Screen(game: PixelAdventure(character: "Virtual Guy", level: "01"));
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
  String name() => "flame";
}
