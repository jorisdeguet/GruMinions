import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'choose_character.dart';

class SplashScreenGame extends StatefulWidget {
  const SplashScreenGame({super.key});

  @override
  SplashScreenGameState createState() => SplashScreenGameState();
}

class SplashScreenGameState extends State<SplashScreenGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
        showBefore: (BuildContext context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: DefaultTextStyle(
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    FadeAnimatedText('GameWithY'),
                    FadeAnimatedText(''),
                  ],
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
            ),
          );
        },
        showAfter: (BuildContext context) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: DefaultTextStyle(
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Pixel Adventure Remake'),
                    TypewriterAnimatedText('A Flame Game'),
                  ],
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
            ),
          );
        },
        theme: FlameSplashTheme.dark,
        onFinish: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChooseCharacter()),
        ),
      ),
    );
  }
}
