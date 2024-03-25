import 'package:flutter/material.dart';

class ScreenLevel extends StatefulWidget {
  const ScreenLevel({
    super.key,
    required this.character,
  });

  final String character;

  @override
  State<ScreenLevel> createState() => _ScreenLevelState();
}

class _ScreenLevelState extends State<ScreenLevel> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('View Level')],
        ),
      ),
    );
  }
}
