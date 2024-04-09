import 'package:blinking_text/blinking_text.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/options/settings/waiting_settings.dart';

import '../../comm/message.dart';

class ScreenSettings extends StatefulWidget {
  final String macAddress;

  const ScreenSettings({
    super.key,
    required this.macAddress,
  });

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {

  Color player1Color = const Color(0xff30acd9);
  Color player2Color = const Color(0xffcc3048);
  Color color = Colors.black;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: 300,
                height: 600,
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
                      'Player 1',
                      style: GoogleFonts.pixelifySans(
                        textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: player1Color,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: SpriteAnimationWidget.asset(
                        path: "Main Characters/${currentConfig.playerName}/Idle (32x32).png",
                        //player 1's character
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
                        beginColor: player1Color,
                        endColor: Colors.transparent,
                        times: 3600,
                        duration: const Duration(seconds: 2)),
                    const SizedBox(height: 40),
                    const Divider(
                      thickness: 2,
                      color: Colors.black38,
                      indent: 10,
                      endIndent: 10,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    currentConfig.friendName == null
                    ? const WaitingSettings()
                    : Center(
                      child: Column(
                        children: [
                          Text(
                            'Player 2',
                            style: GoogleFonts.pixelifySans(
                              textStyle: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: player2Color,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: SpriteAnimationWidget.asset(
                              path: "Main Characters/${currentConfig.friendName}/Idle (32x32).png",
                              //player 1's character
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
                              beginColor: player2Color,
                              endColor: Colors.transparent,
                              times: 3600,
                              duration: const Duration(seconds: 2)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentConfig.level.toUpperCase(),
                      style: GoogleFonts.pixelifySans(
                        textStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 512,
                      height: 288,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          image: AssetImage(
                              'assets/images/Background/${currentConfig.level}.gif'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
