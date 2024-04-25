
import 'package:flutter/material.dart';

class GruBugCatcherMainMenuPage extends StatefulWidget{
  final Function sendOthersTCP;
  final Function sendOthersUDP;

  const GruBugCatcherMainMenuPage({Key? key, required this.sendOthersTCP, required this.sendOthersUDP}) : super(key: key);

  @override
  GruBugCatcherMainMenuPageState createState() => GruBugCatcherMainMenuPageState();
}

class GruBugCatcherMainMenuPageState extends State<GruBugCatcherMainMenuPage>{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Bug Catcher Main Menu Page', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ],
        ));
  }
}