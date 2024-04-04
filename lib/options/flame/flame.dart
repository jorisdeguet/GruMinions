import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gru_minions/comm/message.dart';
import 'package:gru_minions/options/flame/game/pixel_adventure.dart';
import 'package:gru_minions/options/flame/screen_game.dart';

import '../base/base-mode.dart';
import 'controller.dart';
import 'helpers/direction.dart';

// taken from https://github.com/flame-games/player_move
class FlameMode extends ScreenControllerOption {
  FlameMode({required super.sendToOthers});

  late final PixelAdventure _game = PixelAdventure(
      characterPlayer1: currentConfig.characterPlayer1,
      characterPlayer2: currentConfig.characterPlayer1,
      level: currentConfig.level.split('').last);

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
    return ScreenGame(
      game: _game,
    );
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    if (kDebugMode) {
      print(s);
    }

    Direction d = Direction.values.firstWhere((e) => s.contains(e.name));
    if (kDebugMode) {
      print("Good  $d");
    }
    _game.onJoyPad1DirectionChanged(d);
  }

  @override
  String name() => "flame";
}
