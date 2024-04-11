import 'dart:math';

import 'package:flutter/cupertino.dart';

class CustomCircle extends CustomPainter {
  final double right;
  final double bottom;
  final Color color;
  final double rad;

  CustomCircle(this.color, this.rad, this.right, this.bottom);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, right, bottom);
    final startAngle = pi * rad;
    const sweepAngle = pi / 3;
    const useCenter = false;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 15;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}