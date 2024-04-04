import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaitingSettings extends StatefulWidget {
  const WaitingSettings({super.key});

  @override
  State<WaitingSettings> createState() => _WaitingSettingsState();
}

class _WaitingSettingsState extends State<WaitingSettings> {

  //define the variables
  Color player2Color = const Color(0xffcc3048);
  Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
