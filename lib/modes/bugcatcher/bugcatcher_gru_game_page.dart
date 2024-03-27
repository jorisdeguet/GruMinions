import 'package:flutter/material.dart';

class GruBugCatcherPage extends StatefulWidget {
  final Function send;

  const GruBugCatcherPage({super.key, required this.send});

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
              child: Text('BugCatcher Game Page', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
          ],
        ));
  }
}
