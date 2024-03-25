import 'package:flutter/material.dart';

import 'helpers/joypad.dart';

class Controller extends StatefulWidget {
  final Function send;

  const Controller({super.key, required this.send});

  @override
  ControllerState createState() => ControllerState();
}

class ControllerState extends State<Controller> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: JoyPad(onDirectionChanged: (direction) {
                  widget.send(direction.toString());
                }),
              ),
            )
          ],
        ));
  }
}
