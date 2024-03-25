import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/pixel_adventure.dart';

class TimerBar extends StatelessWidget {
  const TimerBar({
    super.key,
    required this.game,
    required this.time,
  });

  final PixelAdventure game;

  //Final variables
  final ValueNotifier<int> time;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: time,
        builder: (context, score, child) {
          return Text(
            'Time: ${_formatDuration(Duration(seconds: time.value))}',
            style: GoogleFonts.pixelifySans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w200,
              fontStyle: FontStyle.normal,
            ),
          );
        });
  }
}
