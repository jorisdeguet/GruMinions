import 'package:flutter/material.dart';
import 'package:gru_minions/modes/base/base-mode.dart';
import 'package:gru_minions/modes/player/controller_character.dart';
import 'package:gru_minions/modes/flame/helpers/direction.dart';
import 'package:gru_minions/modes/player/view_character.dart';


// taken from https://github.com/flame-games/player_move
class CharacterMode extends GruMinionMode {
  CharacterMode({required super.sendToOthers});

  @override
  void initController() {}

  @override
  void initScreen() {}

  @override
  Widget controllerWidget() {
    return const ControllerCharacter();
  }

  @override
  Widget screenWidget(BuildContext context) {
    return const ViewCharacter();
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
  String name() => "character_mode";
}
