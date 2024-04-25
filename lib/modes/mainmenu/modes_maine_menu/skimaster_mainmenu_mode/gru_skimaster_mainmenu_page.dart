import 'package:flutter/material.dart';

class GruSkiMasterMainMenuPage extends StatefulWidget{
  final Function sendOthersTCP;
  final Function sendOthersUDP;

  const GruSkiMasterMainMenuPage({super.key , required this.sendOthersTCP, required this.sendOthersUDP});

  @override
  GruSkiMasterMainMenuPageState createState() => GruSkiMasterMainMenuPageState();
}

class GruSkiMasterMainMenuPageState extends State<GruSkiMasterMainMenuPage>{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Ski Master Main Menu Page', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ],
        ));
  }
}