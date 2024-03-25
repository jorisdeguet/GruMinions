import 'package:flutter/material.dart';


class ScreenCharacter extends StatefulWidget {
  const ScreenCharacter({super.key});

  @override
  State<ScreenCharacter> createState() => _ScreenCharacterState();
}

class _ScreenCharacterState extends State<ScreenCharacter> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('View Character')
          ],
        ),
      ),
    );
  }
}