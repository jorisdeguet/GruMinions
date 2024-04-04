import 'package:flutter/material.dart';

import 'helpers/skimaster_joypad.dart';






class ControllerAGamePage extends StatefulWidget {
  final Function send;

  const ControllerAGamePage({required this.send});

  @override
  ControllerAGameState createState() => ControllerAGameState();
}

class ControllerAGameState extends State<ControllerAGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(75.0),
                child: Joypad(
                  onDirectionChanged: (direction) {
                    widget.send('ControllerA,' + direction.toString());
                  },
                ),
              ),
            ),
          ],
        ));
  }
}