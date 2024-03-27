import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenLevel extends StatefulWidget {
  final ValueNotifier<String> levelName;

  const ScreenLevel({
    super.key,
    required this.levelName,
  });

  @override
  State<ScreenLevel> createState() => _ScreenLevelState();
}

class _ScreenLevelState extends State<ScreenLevel> {
  @override
  void initState() {
    widget.levelName.value = 'Level 01';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: widget.levelName,
        builder: (context, score, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.levelName.value.toUpperCase(),
                  style: GoogleFonts.pixelifySans(
                    textStyle: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 512,
                  height: 288,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: AssetImage(
                          'assets/images/Background/${widget.levelName.value}.gif'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

