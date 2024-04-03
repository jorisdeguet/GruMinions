import 'package:flutter/material.dart';
import 'package:gru_minions/comm/message.dart';
import '../base/base-mode.dart';
import 'controller_character.dart';
import 'screen_character.dart';

// taken from https://github.com/flame-games/player_move
class CharacterOption extends ScreenControllerOption {
  CharacterOption({required super.sendToOthers});

  final ValueNotifier<String> _character1 = ValueNotifier<String>('');
  final ValueNotifier<String> _character2 = ValueNotifier<String>('');

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
    return ScreenCharacter(characterPlayer1: _character1, characterPlayer2: _character1);
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    // receive the character name
    if(s.startsWith("Selected")){
      currentConfig.characterPlayer1 = s.split(':').last;
    }
    else if (s.startsWith("View")){
      _character1.value = s.split(':').last;
    }
  }

  @override
  String name() => "character_option";
}
