import 'package:flutter/material.dart';
import '../flame/helpers/a_button.dart';
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
                        widget.send('ControllerB,${isPressed ? true : false}');
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
