import 'package:blinking_text/blinking_text.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../comm/message.dart';

class ControllerSettings extends StatefulWidget {
  final String macAddress;

  const ControllerSettings({super.key, required this.macAddress});

  @override
  State<ControllerSettings> createState() => _ControllerSettingsState();
}

class _ControllerSettingsState extends State<ControllerSettings> {
  late Color playerColor;
  late String myCharacter;

  @override
  void initState() {
    if (id == 1) {
      myCharacter = currentConfig.characterPlayer1;
      playerColor = const Color(0xff30acd9);
    } else if (id == 2) {
      myCharacter = currentConfig.characterPlayer2!;
      playerColor = const Color(0xffcc3048);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyCharacter(
                    characterName: myCharacter,
                    playerColor: playerColor,
                  ),
            ],
          ),
        ));
  }
}

class MyCharacter extends StatelessWidget {
  final String characterName;
  final Color playerColor;

  const MyCharacter(
      {super.key, required this.characterName, required this.playerColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black38,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'My Character',
              style: GoogleFonts.pixelifySans(
                textStyle: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: playerColor,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: SpriteAnimationWidget.asset(
                path: "Main Characters/$characterName/Idle (32x32).png",
                data: SpriteAnimationData.sequenced(
                  amount: 11,
                  stepTime: 0.05,
                  textureSize: Vector2(32, 32),
                  loop: true,
                ),
              ),
            ),
            BlinkText('Connected',
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                beginColor: playerColor,
                endColor: Colors.transparent,
                times: 3600,
                duration: const Duration(seconds: 2)),
          ],
        ),
    );
  }
}
