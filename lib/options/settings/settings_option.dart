import 'package:flutter/material.dart';
import 'package:gru_minions/options/settings/controller_settings.dart';
import 'package:gru_minions/options/settings/screen_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base/base-mode.dart';
import '../flame/helpers/direction.dart';

// taken from https://github.com/flame-games/player_move
class SettingsOption extends ScreenControllerOption {
  SettingsOption({required super.sendToOthers});

  @override
  void initController() {}

  @override
  void initScreen() {}

  @override
  Widget controllerWidget() {
    return ControllerSettings(
      macAddress: macAddress(),
    );
  }

  @override
  Widget screenWidget(BuildContext context) {
    return ScreenSettings(macAddress: macAddress());
  }

  @override
  void handleMessageAsGru(String s) {}

  @override
  void handleMessageAsMinion(String s) {}

  @override
  String name() => "settings_option";
}
