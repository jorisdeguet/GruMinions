import 'package:gru_minions/modes/base/base-mode.dart';
import 'package:gru_minions/modes/flame/flame.dart';
import 'package:gru_minions/modes/level/level_mode.dart';

import 'character/character_mode.dart';

List<ScreenControllerOption> listOfModes(Function send) {
  return [
    CharacterMode(sendToOthers: send),
    LevelMode(sendToOthers: send),
    FlameMode(sendToOthers: send),
  ];
}
