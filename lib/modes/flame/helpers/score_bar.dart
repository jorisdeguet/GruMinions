import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreBar extends StatelessWidget {
  const ScoreBar({
    super.key,
    required this.score,
  });

  //Final variables
  final ValueNotifier<int> score;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: score,
      builder: (context, score, child) {
        return Text(
          'Score: $score'.toUpperCase(),
          style: GoogleFonts.pixelifySans(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w200,
            fontStyle: FontStyle.normal,
          ),
        );
      },
    );
  }
}
