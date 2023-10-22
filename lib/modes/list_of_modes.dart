

import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/halloween.dart';
import 'package:gru_minions/modes/miroir.dart';
import 'package:gru_minions/modes/piano.dart';
import 'package:gru_minions/modes/simon.dart';
import 'package:gru_minions/modes/tapelelapin.dart';

List<GruMinionMode> listOfModes(Function send) {
  return [
    PianoMode(sendToOthers: send),
    Miroir.forGru(sendToOthers: send),
    HalMode(sendToOthers: send),
    TapeLeLapin(sendToOthers: send),
    SimonMode(sendToOthers: send),
  ];
}