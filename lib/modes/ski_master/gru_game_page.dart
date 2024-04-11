import 'package:flutter/material.dart';

class GruSkiMasterPage extends StatefulWidget {
  final Function sendTCP;
  final Function sendUDP;

  const GruSkiMasterPage({super.key, required this.sendTCP, required this.sendUDP});

  @override
  GruSkiMasterState createState() => GruSkiMasterState();
}

class GruSkiMasterState extends State<GruSkiMasterPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Ski Master Game Page',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ],
        ));
  }
}
