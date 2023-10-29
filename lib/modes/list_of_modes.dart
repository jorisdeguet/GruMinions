

import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/flame.dart';
import 'package:gru_minions/modes/grid.dart';
import 'package:gru_minions/modes/halloween.dart';
import 'package:gru_minions/modes/matrix.dart';
import 'package:gru_minions/modes/miroir.dart';
import 'package:gru_minions/modes/piano.dart';
import 'package:gru_minions/modes/simon.dart';
import 'package:gru_minions/modes/synchro.dart';
import 'package:gru_minions/modes/tapelelapin.dart';

List<GruMinionMode> listOfModes(Function send) {
  return [
    PianoMode(sendToOthers: send),
    Miroir(sendToOthers: send),
    HalMode(sendToOthers: send),
    GridMode(sendToOthers: send),
    SyncMode(sendToOthers: send),
    TapeLeLapin(sendToOthers: send),
    SimonMode(sendToOthers: send),
    FlameMode(sendToOthers: send),
    MatrixMode(sendToOthers: send),
  ];
}