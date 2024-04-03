import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gru_minions/modes/ski_master/helpers/skimaster_direction.dart';

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
      height: 240,
      width: 240,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(240),
        ),
        child: GestureDetector(
          onPanDown: _onDragDown,
          onPanUpdate: _onDragUpdate,
          onPanEnd: _onDragEnd,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x88ffffff),
              borderRadius: BorderRadius.circular(120),
            ),
            child: Center(
              child: Transform.translate(
                offset: delta,
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xccffffff),
                      borderRadius: BorderRadius.circular(120),
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
    if (offset.dx > 19) {
      return Direction.right;
    } else if (offset.dx < -19) {
      return Direction.left;
    } else if (offset.dy > 19) {}
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
    final newDelta = offset - const Offset(120, 120);
    _updateDelta(
      Offset.fromDirection(
        newDelta.direction,
        min(60, newDelta.distance),
      ),
    );
  }
}
