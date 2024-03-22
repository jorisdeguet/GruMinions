import 'package:flutter/material.dart';

import '../boxsmasher/helpers/joypad.dart';
import 'helpers/masterfuldiviner_a_button.dart';

class ControllerAMasterfulDivinerPage extends StatefulWidget {
  final Function send;

  const ControllerAMasterfulDivinerPage({super.key, required this.send});

  @override
  ControllerAMasterfulDivinerState createState() => ControllerAMasterfulDivinerState();
}

class ControllerAMasterfulDivinerState extends State<ControllerAMasterfulDivinerPage> {

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
                        widget.send('ControllerA,${isPressed ? true : false}');
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
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
