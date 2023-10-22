import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/list_of_modes.dart';
import 'package:gru_minions/service/boss_service.dart';
import 'package:gru_minions/widget/boss_base_widget.dart';


class GruTestAppPage extends StatefulWidget {
  const GruTestAppPage({super.key});

  @override
  State<GruTestAppPage> createState() => _BossTestAppPageState();
}

class _BossTestAppPageState extends BossBaseWidgetState<GruTestAppPage> {


  late List<GruMinionMode> modes = listOfModes(send);
  late GruMinionMode currentMode;


  void changeMode(String m) {
    for (GruMinionMode mode in modes)
      if (m == mode.name()) currentMode = mode;
    send(m);
    currentMode.initGru();
    setState(() {});
  }

  @override
  void initState() {
    //Get.put(BossService());
    super.initState();
    Get.find<GruService>().onReceive.stream.forEach((element) {
      receive(element);
    });
    changeMode(modes[0].name());
  }

  @override
  Widget content(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Gru mode " + currentMode.name()),
      ),
      body: Column(
        children: [
          Text('Test App Page current mode ' + currentMode.name()),
          MaterialButton(
              onPressed: () {
                send("pipo");
              },
              child: Text("pipo"),
          ),
          gestionDesModes(),
          Expanded(child: currentMode.gruWidget()),
        ],
      ),
    );
  }

  Expanded gestionDesModes() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: this.modes.map( buttonForMode).toList(),
      ),
    );
  }

  void send(String m) {
    Get.find<GruService>().p2p.sendStringToSocket(m);
  }

  void receive(String m) {
    //print("Gru widget got  ::: " + m);
    currentMode.handleMessageAsGru(m);
    setState(() {});
  }

  Widget buttonForMode(GruMinionMode e) {
    return MaterialButton(
        color: Colors.amber,
        onPressed: () {
          changeMode(e.name());
        },
        child : Text(e.name(), style: TextStyle(fontSize: 25),)
    );
  }
}
