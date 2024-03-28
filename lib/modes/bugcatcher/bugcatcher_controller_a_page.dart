import 'package:flutter/material.dart';


import 'helpers/bugcatcher_a_button.dart';
import 'helpers/bugcatcher_b_button.dart';
import 'helpers/bugcatcher_joypad.dart';

class ControllerABugCatcherPage extends StatefulWidget {
  final Function send;

  const ControllerABugCatcherPage({super.key, required this.send});

  @override
  ControllerABugCatcherState createState() => ControllerABugCatcherState();
}

class ControllerABugCatcherState extends State<ControllerABugCatcherPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child:
                      AButton(onAButtonChanged: (isPressed) {
                        widget.send('ControllerA,ButtonA,${isPressed ? true : false}');
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child:
                      BButton(onBButtonChanged: (isPressed) {
                        widget.send('ControllerA,ButtonB,${isPressed ? true : false}');
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(75.0),
                child: Joypad(
                  onDirectionChanged: (direction) {
                    widget.send('ControllerA,$direction');
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
