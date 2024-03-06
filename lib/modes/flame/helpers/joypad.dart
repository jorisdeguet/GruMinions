import 'package:flutter/material.dart';

import 'direction.dart';

class JoyPad extends StatefulWidget {
  final ValueChanged<Direction>? onDirectionChanged;

  const JoyPad({super.key, this.onDirectionChanged});

  @override
  JoyPadState createState() => JoyPadState();
}

class JoyPadState extends State<JoyPad> {
  Direction direction = Direction.none;
  Offset delta = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          iconSize: 120,
          onPressed: () {
            _moveLeft();
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          iconSize: 120,
          onPressed: () {
            _moveRight();
          },
        ),
      ],
    );
  }

  void _moveLeft() {
    direction = Direction.left;
    widget.onDirectionChanged!(direction);
  }

  void _moveRight() {
    direction = Direction.right;
    widget.onDirectionChanged!(direction);
  }

  void _jump() {
    direction = Direction.up;
    widget.onDirectionChanged!(direction);
  }
}
