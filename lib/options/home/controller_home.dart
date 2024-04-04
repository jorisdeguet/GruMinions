
import 'package:blinking_text/blinking_text.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/comm/message.dart';
import 'package:stroke_text/stroke_text.dart';

int id = 0;

class ControllerHome extends StatefulWidget {
  const ControllerHome({
    super.key,
  });

  @override
  State<ControllerHome> createState() => _ControllerHomeState();
}

class _ControllerHomeState extends State<ControllerHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StrokeText(
              text: 'Pixel Adventure',
              strokeColor: Colors.black,
              strokeWidth: 2,
              textStyle: GoogleFonts.pixelifySans(
                textStyle: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffea71bd),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: SpriteAnimationWidget.asset(
                            path: "Main Characters/Mask Dude/Run (32x32).png",
                            //running
                            data: SpriteAnimationData.sequenced(
                              amount: 12,
                              stepTime: 0.05,
                              textureSize: Vector2(32, 32),
                              loop: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff6cd9f1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: SpriteAnimationWidget.asset(
                            path: "Main Characters/Ninja Frog/Run (32x32).png",
                            data: SpriteAnimationData.sequenced(
                              amount: 12,
                              stepTime: 0.05,
                              textureSize: Vector2(32, 32),
                              loop: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xffcc3048),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: SpriteAnimationWidget.asset(
                            path: "Main Characters/Pink Man/Run (32x32).png",
                            data: SpriteAnimationData.sequenced(
                              amount: 12,
                              stepTime: 0.05,
                              textureSize: Vector2(32, 32),
                              loop: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff288610),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: SpriteAnimationWidget.asset(
                            path: "Main Characters/Virtual Guy/Run (32x32).png",
                            data: SpriteAnimationData.sequenced(
                              amount: 12,
                              stepTime: 0.05,
                              textureSize: Vector2(32, 32),
                              loop: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlinkText('Swipe right to open the menu!',
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                beginColor: Colors.black,
                endColor: Colors.transparent,
                times: 3600,
                duration: const Duration(seconds: 2)),
          ],
        ),
      ),
    );
  }
}
