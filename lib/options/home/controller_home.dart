import 'package:blinking_text/blinking_text.dart';
import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/comm/message.dart';
import 'package:stroke_text/stroke_text.dart';

class ControllerHome extends StatefulWidget {
  const ControllerHome({
    super.key,
  });

  @override
  State<ControllerHome> createState() => _ControllerHomeState();
}

class _ControllerHomeState extends State<ControllerHome> {

  @override
  void initState() {
    // Show dialog only on the first launch when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!firstLaunch) {
        firstLaunch = true; //the local value for firstLaunch is set to true
        showDialog(
          barrierDismissible: false,
          // Set to false to prevent closing on tap outside
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Welcome to Pixel Adventure',
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              content: Text(
                'Select your player',
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          id = 1; //the local value for id is set to 1
                          Navigator.pop(context);
                          debugPrint('Player\'s ID : $id');
                        },
                        child: Text(
                          'Player 1',
                          style: GoogleFonts.pixelifySans(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )),
                    const SizedBox(width: 15),
                    ElevatedButton(
                        onPressed: () {
                          id = 2; //the local value for id is set to 2
                          //player 2 exist so we define a default character
                          currentConfig.friendName = 'Mask Dude';
                          Navigator.pop(context);
                          debugPrint('Player\'s ID : $id');
                        },
                        child: Text(
                          'Player 2',
                          style: GoogleFonts.pixelifySans(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            );
          },
        );
      }
    });

    super.initState();
  }

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
                            path: 'Main Characters/Mask Dude/Run (32x32).png',
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
                            path: 'Main Characters/Ninja Frog/Run (32x32).png',
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
                            path: 'Main Characters/Pink Man/Run (32x32).png',
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
                            path: 'Main Characters/Virtual Guy/Run (32x32).png',
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
