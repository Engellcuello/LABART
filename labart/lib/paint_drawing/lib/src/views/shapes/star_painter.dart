import 'dart:math';
import 'package:flutter/material.dart';

class StarPainter extends CustomPainter {
  StarPainter({
    required this.lineColor,
    required this.thickness,
    required this.backgroundColor,
  });

  final Color lineColor;
  final Color backgroundColor;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Calculate outer and inner radii for the star's points
    final outerRadiusX = size.width / 2;
    final outerRadiusY = size.height / 2;
    final innerRadiusX = outerRadiusX / 2.5;
    final innerRadiusY = outerRadiusY / 2.5;
    const angleStep = (2 * pi) / 5;

    // Paint for the background (fill)
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    // Paint for the border (stroke) of the star
    final borderPaint = Paint()
      ..color = lineColor
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    // Generate the points of the star
    for (var i = 0; i < 5; i++) {
      final outerX = center.dx + outerRadiusX * cos(i * angleStep - pi / 2);
      final outerY = center.dy + outerRadiusY * sin(i * angleStep - pi / 2);
      final innerX =
          center.dx + innerRadiusX * cos((i + 0.5) * angleStep - pi / 2);
      final innerY =
          center.dy + innerRadiusY * sin((i + 0.5) * angleStep - pi / 2);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();

    // Draw the background (fill)
    canvas
      ..drawPath(path, backgroundPaint)
      // Draw the border of the star
      ..drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always redraw
  }
}
