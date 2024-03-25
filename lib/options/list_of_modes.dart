import 'package:gru_minions/options/home/home_option.dart';

import 'base/base-mode.dart';
import 'character/character_option.dart';
import 'flame/flame.dart';
import 'level/level_option.dart';
import 'settings/settings_option.dart';

List<ScreenControllerOption> listOfModes(Function send) {
  return [
    HomeOption(sendToOthers: send),
    FlameMode(sendToOthers: send),
    CharacterOption(sendToOthers: send),
    LevelOption(sendToOthers: send),
    SettingsOption(sendToOthers: send),
  ];
}
