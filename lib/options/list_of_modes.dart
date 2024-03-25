import 'base/base-mode.dart';
import 'character/character_mode.dart';
import 'flame/flame.dart';
import 'level/level_mode.dart';

List<ScreenControllerOption> listOfModes(Function send) {
  return [
    CharacterMode(sendToOthers: send),
    LevelMode(sendToOthers: send),
    FlameMode(sendToOthers: send),
  ];
}
