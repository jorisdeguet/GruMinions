import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/flame/controller.dart';
import 'package:gru_minions/modes/flame/game/choose_character.dart';
import 'package:gru_minions/modes/flame/helpers/direction.dart';
import 'package:gru_minions/modes/flame/screen.dart';

import 'flame/game/pixel_adventure.dart';

// taken from https://github.com/flame-games/player_move
class ChoosePlayerMode extends GruMinionMode {
  ChoosePlayerMode({required super.sendToOthers});

  final PixelAdventure _game = PixelAdventure(character: "Virtual Guy", level: "01");

  late Function _setMinionDirection;

  @override
  void initController() {}

  @override
  void initScreen() {}

  @override
  Widget controllerWidget() {
    return const ChooseCharacter();
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
