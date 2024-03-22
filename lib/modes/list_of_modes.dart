import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/flame.dart';
import 'package:gru_minions/modes/masterfuldiviner.dart';

import 'boxsmasher.dart';

List<GruMinionMode> listOfModes(Function send) {
  return [
    //SyncMode(sendToOthers: send),
    //PianoMode(sendToOthers: send),
    //Miroir(sendToOthers: send),
    //HalMode(sendToOthers: send),
    //GridMode(sendToOthers: send),
    //TapeLeLapin(sendToOthers: send),
    //SimonMode(sendToOthers: send),
    FlameMode(sendToOthers: send),
    BoxSmasherMode(sendToOthers: send),
    MasterfulDivinerMode(sendToOthers: send),
    //MatrixMode(sendToOthers: send),
  ];
}
