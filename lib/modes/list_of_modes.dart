import 'package:gru_minions/modes/base/base-mode.dart';
import 'package:gru_minions/modes/flame/flame.dart';
import 'package:gru_minions/modes/level/level_mode.dart';
import 'package:gru_minions/modes/player/character_mode.dart';
import 'package:gru_minions/modes/synchro/synchro.dart';

List<GruMinionMode> listOfModes(Function send) {
  return [
    CharacterMode(sendToOthers: send),
    SyncMode(sendToOthers: send),
    LevelMode(sendToOthers: send),
    FlameMode(sendToOthers: send),
  ];
}

List<String> listOfLevels() {
  return [
    'Level-01',
    'Level-02',
    'Level-03',
    'Level-04',
    'Level-05',
    'Level-06',
    'Level-07',
    'Level-08',
    'Level-09',
  ];
}
