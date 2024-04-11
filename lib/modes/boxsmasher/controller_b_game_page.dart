import 'package:flutter/material.dart';
import 'helpers/a_button.dart';
import 'helpers/b_button.dart';
import 'helpers/joypad.dart';

class ControllerBBoxSmasherPage extends StatefulWidget {
  final Function send;

  const ControllerBBoxSmasherPage({required this.send});

  @override
  ControllerBBoxSmasherState createState() => ControllerBBoxSmasherState();
}

class ControllerBBoxSmasherState extends State<ControllerBBoxSmasherPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: FilledButton(
                  child: const Text('Explanations'),
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
                      padding: const EdgeInsets.all(50.0),
                      child:
                      AButton(onAButtonChanged: (isPressed) {
                        widget.send('ControllerB,ButtonA,VerifyScore');
                        widget.send('ControllerB,ButtonA,${isPressed ? true : false}');
                        }
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(50.0),
                      child:
                      BButton(onBButtonChanged: (isPressed) {
                        widget.send('ControllerB,ButtonB,${isPressed ? true : false}');
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
                    widget.send('ControllerB,$direction');
                  },
                ),
              ),
            ),
          ],
        ));
  }
}