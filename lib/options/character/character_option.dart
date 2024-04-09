import 'package:flutter/material.dart';
import 'package:gru_minions/comm/message.dart';
import '../base/base_mode.dart';
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
    return ScreenCharacter(playerName: _character1, friendName: _character2);
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    // treat the message depending on the player's id
    if(s.startsWith("1 has selected")){
      currentConfig.playerName = s.split(':').last;
    }
    else if (s.startsWith("1's current view:")){
      _character1.value = s.split(':').last;
    }
    else if(s.startsWith("2 has selected")){
      currentConfig.friendName = s.split(':').last;
    }
    else if (s.startsWith("2's current view:")){
      _character2.value = s.split(':').last;
    }
  }

  @override
  String name() => "character_option";
}
