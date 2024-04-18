import 'package:flutter/material.dart';

class GruMainMenuPage extends StatefulWidget{
  final Function sendOthersTCP;
  final Function sendOthersUDP;

  const GruMainMenuPage({Key? key, required this.sendOthersTCP, required this.sendOthersUDP}) : super(key: key);

  @override
  GruMainMenuPageState createState() => GruMainMenuPageState();
}

class GruMainMenuPageState extends State<GruMainMenuPage>{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Main Menu Page', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ],
        ));
  }
}