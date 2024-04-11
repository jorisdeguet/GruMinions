import 'package:flutter/material.dart';
import 'package:gru_minions/comm/message.dart';
import 'package:gru_minions/options/flame/game/pixel_adventure.dart';
import 'package:gru_minions/options/flame/screen_game.dart';

import '../base/base_mode.dart';
import 'controller.dart';
import 'helpers/direction.dart';

// taken from https://github.com/flame-games/player_move
class FlameMode extends ScreenControllerOption {
  FlameMode({required super.sendToOthers});

  late final PixelAdventure _game = PixelAdventure(
      playerName: currentConfig.playerName,
      friendName: currentConfig.friendName,
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
    List<String> split = s.split(':');

    if(split[0] == '1') {
      Direction d = Direction.values.firstWhere((e) => split[1].contains(e.name));
      debugPrint("Controller 1 : $d");
      _game.onController1DirectionChanged(d);
      return;
    }

    if(split[0] == '2') {
      Direction d = Direction.values.firstWhere((e) => split[1].contains(e.name));
      debugPrint("Controller 2 : $d");
      _game.onController2DirectionChanged(d);
      return;
    }
  }

  @override
  String name() => "flame";
}
