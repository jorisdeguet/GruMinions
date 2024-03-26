import 'dart:ui';

import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image:
            const AssetImage('assets/images/Background/Wallpaper2.gif'),
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Padding(
                  padding: const EdgeInsets.only(left: 160.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
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
                        BlinkText(
                            'Swipe right to open the menu',
                            style: GoogleFonts.pixelifySans(
                              textStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            beginColor: Colors.black,
                            endColor: Colors.transparent,
                            times: 100,
                            duration: const Duration(seconds: 1)
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
