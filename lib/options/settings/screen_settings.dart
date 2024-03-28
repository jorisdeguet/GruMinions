import 'package:blinking_text/blinking_text.dart';
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
  Color color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
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
                  'Settings',
                  style: GoogleFonts.pixelifySans(
                    textStyle: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.normal,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Music : 50%',
                  style: GoogleFonts.pixelifySans(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Text(
                  'SoundFX : 50%',
                  style: GoogleFonts.pixelifySans(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Text(
                  'Sound : On',
                  style: GoogleFonts.pixelifySans(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Text(
                  'Full Screen : On',
                  style: GoogleFonts.pixelifySans(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                Text(
                  'Language: English',
                  style: GoogleFonts.pixelifySans(
                    textStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                BlinkText('Use the controller to change settings',
                    style: GoogleFonts.pixelifySans(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    beginColor: color,
                    endColor: Colors.transparent,
                    times: 3600,
                    duration: const Duration(seconds: 2)),
                Text(
                  widget.macAddress,
                  style: GoogleFonts.pixelifySans(
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
