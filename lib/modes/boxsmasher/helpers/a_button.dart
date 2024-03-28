import 'package:flutter/material.dart';

class AButton extends StatefulWidget {

  final ValueChanged<bool>? onAButtonChanged;

  const AButton({super.key, this.onAButtonChanged});

  @override
  AButtonState createState() => AButtonState();
}

class AButtonState extends State<AButton> {
  bool isPressed = false;

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
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          child: Container(
            decoration: BoxDecoration(
              color: isPressed ? const Color(0x88ffffff) : const Color(0x44ffffff),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                'A',
                style: TextStyle(
                  fontSize: 48,
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