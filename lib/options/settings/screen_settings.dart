import 'package:blinking_text/blinking_text.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({
    super.key,
    required this.macAddress,
  });

  final String macAddress;

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
                        path: "Main Characters/Pink Man/Idle (32x32).png",
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
                    Text(
                      widget.macAddress,
                      style: GoogleFonts.pixelifySans(
                        textStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: player2Color,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 100,
                    //   height: 100,
                    //   child: SpriteAnimationWidget.asset(
                    //     path: "Main Characters/Virtual Guy/Idle (32x32).png",
                    //     //player 2's character
                    //     data: SpriteAnimationData.sequenced(
                    //       amount: 11,
                    //       stepTime: 0.05,
                    //       textureSize: Vector2(32, 32),
                    //       loop: true,
                    //     ),
                    //   ),
                    // ),
                    BlinkText('Waiting...',
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
                      'Level 01',
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
                        child: const Image(
                          image: AssetImage(
                              'assets/images/Background/Level 01.gif'),
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
