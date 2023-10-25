import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/list_of_modes.dart';
import 'package:gru_minions/service/minion_service.dart';
import 'package:gru_minions/widget/minion_base_widget.dart';


class MainMinionPage extends StatefulWidget {
  const MainMinionPage({super.key});

  @override
  State<MainMinionPage> createState() => _MainMinionPageState();
}

class _MainMinionPageState extends MinionBaseWidgetState<MainMinionPage> {


  late List<GruMinionMode> modes = listOfModes(send);

  late GruMinionMode currentMode = modes[0];


  @override
  void initState() {
    Get.put(MinionService());
    super.initState();
    Get.find<MinionService>().onReceive.listen((element) {
      receive(element);
    });
  }



  @override
  Widget content(BuildContext context) {
    return mainBody();
  }

  Widget mainBody(){
    return currentMode.minionWidget(context);
  }

  void changeMode(String m) {
    for (GruMinionMode mode in modes) {
      if (m == mode.name()) {
        print("Minion mode changed to " + m);
        currentMode = mode;
        currentMode.initMinion();
      }
    }
    setState(() {});
  }


  void send(String m) {
    Get.find<MinionService>().p2p.sendStringToSocket(m);
  }

  void receive(String m) {
    try{
      //print("Minion Widget got :::: " + m);
      changeMode(m);
      currentMode.handleMessageAsMinion(m);
    } catch (e) {
      print("Minion got exception while handling message " + m + "  " +e.toString());
      e.printError();
    }
    setState(() {});
  }
}
