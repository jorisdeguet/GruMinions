import 'package:flutter/material.dart';

class GruBugCatcherPage extends StatefulWidget {
  final Function sendTCP;
  final Function sendUDP;

  const GruBugCatcherPage({super.key, required this.sendTCP, required this.sendUDP});

  @override
  GruBugCatcherState createState() => GruBugCatcherState();
}

class GruBugCatcherState extends State<GruBugCatcherPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text('Page de jeu de BugCatcher', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ],
        ));
  }
}
