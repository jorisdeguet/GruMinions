import 'package:flutter/material.dart';

import 'helpers/skimaster_a_button.dart';
import 'helpers/skimaster_b_button.dart';
import 'helpers/skimaster_joypad.dart';






class ControllerAGamePage extends StatefulWidget {
  final Function sendUDP;

  const ControllerAGamePage({required this.sendUDP});

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
                    widget.sendUDP('ControllerA,$direction');
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: FilledButton(
                  child: const Text('Explications'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 0.0, top: 50.0, bottom: 50.0, left: 50.0),
                      child:
                      AButton(onAButtonChanged: (isPressed) {
                        widget.sendUDP('ControllerA,ButtonA,${isPressed ? true : false}');
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child:
                      BButton(onBButtonChanged: (isPressed) {
                        widget.sendUDP('ControllerA,ButtonB,${isPressed ? true : false}');
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
