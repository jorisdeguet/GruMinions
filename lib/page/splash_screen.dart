import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/page/home_page.dart';


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
                    TypewriterAnimatedText('Arcade'),
                    TypewriterAnimatedText('A Flame Game'),
                  ],
                ),
              ),
            ),
          );
        },
        theme: FlameSplashTheme.dark,
        onFinish: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        ),
      ),
    );
  }
}
