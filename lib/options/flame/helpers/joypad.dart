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
          onTapDown: (d) {
            _moveLeft();
          },
          onTapCancel: () {
            _doesNotMove();
          },
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            iconSize: 120,
            onPressed: () {},
          ),
        ),
        GestureDetector(
          onTapDown: (d) {
            _moveRight();
          },
          onTapCancel: () {
            _doesNotMove();
          },
          child: IconButton(
            icon: const Icon(Icons.arrow_forward),
            iconSize: 120,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 120),
        GestureDetector(
          onTapDown: (d) {
            _jump();
          },
          onTapCancel: () {
            _doesNotJump();
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
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(direction.toString())));
  }

  void _moveLeft() {
    direction = Direction.left;
    widget.onDirectionChanged!(direction);
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(direction.toString())));
  }

  void _moveRight() {
    direction = Direction.right;
    widget.onDirectionChanged!(direction);
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(direction.toString())));
  }

  void _jump() {
    direction = Direction.up;
    widget.onDirectionChanged!(direction);
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(direction.toString())));
  }

  void _doesNotJump() {
    direction = Direction.none;
    widget.onDirectionChanged!(direction);
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(direction.toString())));
  }
}