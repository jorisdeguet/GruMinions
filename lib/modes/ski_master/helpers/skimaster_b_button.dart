import 'package:flutter/material.dart';

class BButton extends StatefulWidget {

  final ValueChanged<bool>? onBButtonChanged;

  const BButton({super.key, this.onBButtonChanged});

  @override
  BButtonState createState() => BButtonState();
}

class BButtonState extends State<BButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
        ),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          child: Container(
            decoration: BoxDecoration(
              color: isPressed ? const Color(0x88ffffff) : const Color(0x44ffffff),
              borderRadius: BorderRadius.circular(160),
            ),
            child: Center(
              child: Text(
                'B',
                style: TextStyle(
                  fontSize: 64,
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
    widget.onBButtonChanged?.call(true);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      isPressed = false;
    });
    widget.onBButtonChanged?.call(false);
  }

}