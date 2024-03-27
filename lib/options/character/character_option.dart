import 'package:flutter/material.dart';
import '../base/base-mode.dart';
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
    return ControllerCharacter(
      send: sendToOthers,
    );
  }

  @override
  Widget screenWidget(BuildContext context) {
    return const ScreenCharacter();
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    // receive the character name
    String c = s;
  }

  @override
  String name() => "character_option";
}
