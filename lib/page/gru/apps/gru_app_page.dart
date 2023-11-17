import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gru_minions/modes/base-mode.dart';
import 'package:gru_minions/modes/list_of_modes.dart';
import 'package:gru_minions/service/gru_service.dart';
import 'package:gru_minions/widget/boss_base_widget.dart';


class GruTestAppPage extends StatefulWidget {
  const GruTestAppPage({super.key});

  @override
  State<GruTestAppPage> createState() => _BossTestAppPageState();
}

class _BossTestAppPageState extends BossBaseWidgetState<GruTestAppPage> {

  bool messagesDebug = true;

  List<String> messages = [];

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
    GruService service = Get.find<GruService>();
    service.onReceive.listen((element) {
      //print("Gru listen " + element);
      receive(element);
    });
    changeMode(modes[0].name());
  }

  @override
  Widget content(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Gru mode " + currentMode.name() + " @" + currentMode.macAddress()),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                gestionDesModes(),
                messagesDebug?messagesList():Container(),
              ],
            ),
          ),
          Expanded(child: currentMode.gruWidget()),
        ],
      ),
    );
  }

  Expanded gestionDesModes() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        children: this.modes.map( buttonForMode).toList(),
      ),
    );
  }

  void send(String m) {
    messages.insert(0,"Gru - " + m);
    Get.find<GruService>().p2p.sendStringToSocket(m);
    setState(() {});
  }

  void receive(String m) {
    // Any exception on handling the message would stop the refresh
    try{
      messages.insert(0,"Minion - " + m);
      currentMode.handleMessageAsGru(m);
    } catch (e) {
      print("Minion got exception while handling message " + m);
      e.printError();
    }
    setState(() {});
  }

  Widget buttonForMode(GruMinionMode e) {
    return MaterialButton(
        color: Colors.greenAccent,
        onPressed: () {
          changeMode(e.name());
        },
        child : Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Text(e.name(), style: TextStyle(fontSize: 15),),
        )
    );
  }

  Widget messagesList() {
    return Expanded(
      child: Column(
        children: [
          MaterialButton(
            color: Colors.red,
            onPressed: () {
              this.messages.clear();
              setState(() {});
            },
            child: Text("Effacer"),
          ),
          Expanded(
            child: ListView(
              children: messages.map(  (e) => Text(e)   ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
