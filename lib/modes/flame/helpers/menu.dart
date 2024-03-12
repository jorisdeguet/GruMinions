import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gru_minions/modes/flame/game.dart';

class Menu extends StatelessWidget {
  const Menu({
    super.key,
    required this.game,
  });

  final MainGame game;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Text(
          'Menu',
          style: GoogleFonts.pixelifySans(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.home, color: Colors.black,),
          label: Text(
            'Home',
            style: GoogleFonts.pixelifySans(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            game.resumeEngine();
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: GoogleFonts.pixelifySans(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
