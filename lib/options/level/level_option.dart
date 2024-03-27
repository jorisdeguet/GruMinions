import 'package:flutter/material.dart';

import '../base/base-mode.dart';
import 'controller_level.dart';
import 'screen_level.dart';

// taken from https://github.com/flame-games/player_move
class LevelOption extends ScreenControllerOption {
  LevelOption({required super.sendToOthers});

  final ValueNotifier<String> _levelName = ValueNotifier<String>('');

  @override
  void initController() {}

  @override
  void initScreen() {}

  @override
  Widget controllerWidget() {
    return ControllerLevel(send: sendToOthers);
  }

  @override
  Widget screenWidget(BuildContext context) {
    return ScreenLevel(levelName: _levelName);
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {
    // receive the level name
    _levelName.value = s;
  }

  @override
  String name() => "level_option";
}