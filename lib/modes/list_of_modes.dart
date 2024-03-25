import 'package:gru_minions/modes/base/base-mode.dart';
import 'package:gru_minions/modes/flame/flame.dart';
import 'package:gru_minions/modes/level/level_mode.dart';
import 'package:gru_minions/modes/player/character_mode.dart';

List<GruMinionMode> listOfModes(Function send) {
  return [
    CharacterMode(sendToOthers: send),
    LevelMode(sendToOthers: send),
    FlameMode(sendToOthers: send),
  ];
}
