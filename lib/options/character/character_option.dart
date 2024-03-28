import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../base/base-mode.dart';
import 'controller_character.dart';
import 'screen_character.dart';

// taken from https://github.com/flame-games/player_move
class CharacterOption extends ScreenControllerOption {
  CharacterOption({required super.sendToOthers});

  final ValueNotifier<String> _characterName = ValueNotifier<String>('');

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
    return ScreenCharacter(characterName: _characterName);
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    // receive the character name
    _characterName.value = s;
  }

  @override
  String name() => "character_option";
}
