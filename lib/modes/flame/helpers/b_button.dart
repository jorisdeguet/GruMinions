import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BButton extends StatefulWidget {

  final ValueChanged<bool>? onAButtonChanged;

  const BButton({Key? key, this.onAButtonChanged}) : super(key: key);

  @override
  BButtonState createState() => BButtonState();
}

class BButtonState extends State<BButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          child: Container(
            decoration: BoxDecoration(
              color: isPressed ? const Color(0x88ffffff) : const Color(0x44ffffff),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                'B',
                style: TextStyle(
                  fontSize: 24,
                  color: isPressed ? const Color(0x88ffffff) : const Color(0x44ffffff),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      isPressed = true;
    });
    widget.onAButtonChanged?.call(true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      isPressed = false;
    });
    widget.onAButtonChanged?.call(false);
  }
}