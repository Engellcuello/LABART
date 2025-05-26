import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  TrianglePainter({
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

    final path = Path();
    // Define points for an equilateral triangle
    final p1 = Offset(size.width / 2, 0);
    final p2 = Offset(0, size.height);
    final p3 = Offset(size.width, size.height);

    // Draw the triangle
    path
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    // Draw the background (fill)
    canvas
      ..drawPath(path, backgroundPaint)
      // Draw the border of the triangle
      ..drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always redraw
  }
}
