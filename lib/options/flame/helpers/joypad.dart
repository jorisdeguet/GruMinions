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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTapUp: (details) {
            _doesNotMove();
          },
          onTapDown: (details) {
            _moveLeft();
          },
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 120,
            onPressed: () {},
          ),
        ),
        GestureDetector(
          onTapUp: (details) {
            _doesNotMove();
          },
          onTapDown: (details) {
            _moveRight();
          },
          child: IconButton(
            icon: const Icon(Icons.arrow_forward),
            iconSize: 120,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 120),
        GestureDetector(
          onTapUp: (details) {
            _doesNotJump();
          },
          onTapDown: (details) {
            _jump();
          },
          child: IconButton(
            icon: const Icon(Icons.arrow_upward),
            iconSize: 120,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  void _doesNotMove() {
    direction = Direction.none;
    widget.onDirectionChanged!(direction);
  }

  void _moveLeft() {
    direction = Direction.left;
    widget.onDirectionChanged!(direction);
  }

  void _moveRight() {
    direction = Direction.right;
    widget.onDirectionChanged!(direction);
  }

  void _doesNotJump() {
    direction = Direction.down;
    widget.onDirectionChanged!(direction);
  }

  void _jump() {
    direction = Direction.up;
    widget.onDirectionChanged!(direction);
  }
}
