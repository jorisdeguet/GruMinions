import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/flame.dart';
import 'package:gru_minions/modes/synchro.dart';

List<GruMinionMode> listOfModes(Function send) {
  return [
    SyncMode(sendToOthers: send),
    FlameMode(sendToOthers: send),
  ];
}

List<String> listOfLevels() {
  return [
    'Level-01',
    'Level-02',
    'Level-03',
    'Level-04',
  ];
}
