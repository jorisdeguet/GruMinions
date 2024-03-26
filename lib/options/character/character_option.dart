import 'package:flutter/material.dart';
import '../base/base-mode.dart';
import '../flame/helpers/direction.dart';
import 'controller_character.dart';
import 'screen_character.dart';

// taken from https://github.com/flame-games/player_move
class CharacterOption extends ScreenControllerOption {
  CharacterOption({required super.sendToOthers});

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
    return const ScreenCharacter();
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
  String name() => "character_option";
}
