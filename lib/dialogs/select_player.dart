import 'package:flutter/material.dart';

class SelectPlayer extends StatefulWidget {
  const SelectPlayer({super.key});

  @override
  State<SelectPlayer> createState() => _SelectPlayerState();
}

class _SelectPlayerState extends State<SelectPlayer> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context, 1);
                },
                child: const Text("Player 1")),
            const SizedBox(width: 15),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 2);
                },
                child: const Text("Player 2")),
          ],
        ),
      ),
    );
  }
}
