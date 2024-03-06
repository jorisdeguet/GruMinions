import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gru_minions/modes/flame/game.dart';

import 'direction.dart';

class Joypad extends StatefulWidget {
  final ValueChanged<Direction>? onDirectionChanged;

  const Joypad({super.key, this.onDirectionChanged});

  @override
  JoypadState createState() => JoypadState();
}

class JoypadState extends State<Joypad> {
  Direction direction = Direction.none;
  Offset delta = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
        ),
        child: GestureDetector(
          onPanDown: _onDragDown,
          onPanUpdate: _onDragUpdate,
          onPanEnd: _onDragEnd,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x88ffffff),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Center(
              child: Transform.translate(
                offset: delta,
                child: SizedBox(
                  height: 60,
                  width: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xccffffff),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateDelta(Offset newDelta) {
    final newDirection = _getDirectionFromOffset(newDelta);

    if (newDirection != direction) {
      direction = newDirection;
      widget.onDirectionChanged!(direction);
    }

    setState(() {
      delta = newDelta;
    });
  }

  Direction _getDirectionFromOffset(Offset offset) {
    if (offset.dx > 20) {
      return Direction.right;
    } else if (offset.dx < -20) {
      return Direction.left;
    } else if (offset.dy > 20) {
      return Direction.down;
    } else if (offset.dy < -20) {
      return Direction.up;
    }
    return Direction.none;
  }

  void _onDragDown(DragDownDetails d) {
    _calculateDelta(d.localPosition);
  }

  void _onDragUpdate(DragUpdateDetails d) {
    _calculateDelta(d.localPosition);
  }

  void _onDragEnd(DragEndDetails d) {
    _updateDelta(Offset.zero);
  }

  void _calculateDelta(Offset offset) {
    final newDelta = offset - const Offset(60, 60);
    _updateDelta(
      Offset.fromDirection(
        newDelta.direction,
        min(30, newDelta.distance),
      ),
    );
  }
}
