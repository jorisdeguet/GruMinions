import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Waiting extends StatefulWidget {
  const Waiting({super.key});

  @override
  State<Waiting> createState() => _WaitingState();
}

class _WaitingState extends State<Waiting> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Player 2 : none',
            style: GoogleFonts.pixelifySans(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlinkText('Waiting for Player 2...',
                  style: GoogleFonts.pixelifySans(
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  beginColor: Colors.black,
                  endColor: Colors.transparent,
                  times: 3600,
                  duration: const Duration(seconds: 2)),
            ],
          ),
        ],
      ),
    );
  }
}
