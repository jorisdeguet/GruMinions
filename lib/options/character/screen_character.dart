import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenCharacter extends StatefulWidget {
  final ValueNotifier<String> characterName;

  const ScreenCharacter({super.key, required this.characterName});

  @override
  State<ScreenCharacter> createState() => _ScreenCharacterState();
}

class _ScreenCharacterState extends State<ScreenCharacter> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: widget.characterName,
      builder: (context, score, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.characterName.value,
                style: GoogleFonts.pixelifySans(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffa14744),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
