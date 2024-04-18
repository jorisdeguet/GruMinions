import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/flame.dart';
import 'package:gru_minions/modes/mainmenu/modes_maine_menu/boxsmasher_mainmenu_mode/boxsmasher_mainmenu.dart';
import 'package:gru_minions/modes/ski_master.dart';
import 'package:gru_minions/modes/bugcatcher.dart';

import 'boxsmasher.dart';
import 'main_menu.dart';

List<GruMinionMode> listOfModes(Function sendTCP, Function sendUDP) {
  return [
    MainMenuMode(sendOthersTCP: sendTCP, sendOthersUDP: sendUDP),
    FlameMode(sendOthersTCP: sendTCP, sendOthersUDP: sendUDP),
    BoxSmasherMode(sendOthersTCP: sendTCP, sendOthersUDP: sendUDP),
    SkiMaster(sendOthersTCP: sendTCP, sendOthersUDP: sendUDP),
    BugCatcherMode(sendOthersTCP: sendTCP, sendOthersUDP: sendUDP),
    BoxSmasherMainMenuMode(sendOthersTCP: sendTCP, sendOthersUDP: sendUDP),
  ];
}
