import 'package:flutter/material.dart';

class GruBoxSmasherMainMenuPage extends StatefulWidget{
  final Function sendOthersTCP;
  final Function sendOthersUDP;

  const GruBoxSmasherMainMenuPage({super.key, required this.sendOthersTCP, required this.sendOthersUDP});

  @override
  GruBoxSmasherMainMenuPageState createState() => GruBoxSmasherMainMenuPageState();
}

class GruBoxSmasherMainMenuPageState extends State<GruBoxSmasherMainMenuPage>{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Box Smasher Main Menu Page', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ],
        ));
  }
}