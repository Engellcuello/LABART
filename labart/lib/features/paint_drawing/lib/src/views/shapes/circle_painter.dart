import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  CirclePainter({
    required this.lineColor,
    required this.thickness,
    required this.backgroundColor,
  });

  final Color lineColor;
  final Color backgroundColor;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the background (fill)
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    // Paint for the border (stroke)
    final borderPaint = Paint()
      ..color = lineColor
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Creating a rectangle to define the boundaries of the oval (ellipse)
    final ovalRect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Draw the background as an oval
    canvas
      ..drawOval(ovalRect, backgroundPaint)
      // Draw the border of the oval
      ..drawOval(ovalRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always redraw
  }
}
