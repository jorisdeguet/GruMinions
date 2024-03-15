import 'package:flutter/material.dart';
import 'package:gru_minions/modes/flame/helpers/joypad.dart';

class GruBoxSmasherPage extends StatefulWidget {
  final Function send;

  const GruBoxSmasherPage({super.key, required this.send});

  @override
  GruBoxSmasherPageState createState() => GruBoxSmasherPageState();
}

class GruBoxSmasherPageState extends State<GruBoxSmasherPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Box Smasher Game Page', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ],
        ));
  }
}
