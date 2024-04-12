import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/flame.dart';
import 'package:gru_minions/modes/ski_master.dart';
import 'package:gru_minions/modes/bugcatcher.dart';

import 'boxsmasher.dart';

List<GruMinionMode> listOfModes(Function sendTCP, Function sendUDP) {
  return [
    FlameMode(sendOthersTCP: sendTCP, sendOthersUDP: sendUDP),
    BoxSmasherMode(sendOthersTCP: sendTCP, sendOthersUDP: sendUDP),
    SkiMaster(sendOthersTCP: sendTCP, sendOthersUDP: sendUDP),
    BugCatcherMode(sendToOthers: send),
  ];
}
