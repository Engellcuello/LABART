import 'dart:math';

import 'package:flutter/material.dart';

// Custom painter class for drawing an arrow on the canvas
class ArrowPainter extends CustomPainter {
  // Constructor to initialize line color and thickness
  ArrowPainter({
    required this.lineColor, // Color of the arrow line
    required this.thickness, // Thickness of the arrow line
  });

  final Color lineColor; // The color of the arrow line
  final double thickness; // The thickness of the arrow line

  @override
  void paint(Canvas canvas, Size size) {
    // Angle of the arrow, set to a full circle (2 * pi)
    const angle = pi * 2;

    // Create a paint object for drawing the arrow
    final paint = Paint()
      ..color = lineColor // Set the color of the arrow
      ..strokeWidth = thickness // Set the thickness of the arrow
      ..style = PaintingStyle.stroke // Use stroke (not fill)
      ..strokeCap = StrokeCap.round; // Set round stroke cap

    // Calculate the length of the arrow
    //(60% of the smaller dimension between width and height)
    final arrowLength = size.width;

    // Starting point of the arrow (left middle side of the canvas)
    final startPoint = Offset(0, size.height / 2);

    // Calculate the end point of the arrow using the angle
    final endPoint = Offset(
      startPoint.dx + arrowLength * cos(angle),
      startPoint.dy + arrowLength * sin(angle),
    );

    // Draw the main body of the arrow (a simple line from start to end)
    canvas.drawLine(startPoint, endPoint, paint);

    // Calculate the size of the arrow head
    var headHeight =
        size.height; // Arrow head size is based on the height of the canvas
    const angleOffset = pi / 6; // Angle for the arrow head lines (30 degrees)

    // Calculate the width of the arrow head based on the height and angle
    var headWidth = headHeight * cos(angleOffset);

    // If the head width is larger than the arrow body, adjust it
    if (headWidth > arrowLength) {
      headHeight = arrowLength / cos(angleOffset);
      headWidth = arrowLength;
    }

    // Calculate the two points for the left and right arrowhead lines
    final arrowLeft = Offset(
      endPoint.dx + headHeight * cos(angle + pi - angleOffset),
      endPoint.dy + headHeight * sin(angle + pi - angleOffset),
    );
    final arrowRight = Offset(
      endPoint.dx + headHeight * cos(angle + pi + angleOffset),
      endPoint.dy + headHeight * sin(angle + pi + angleOffset),
    );

    // Draw the left and right lines of the arrow head
    canvas
      ..drawLine(endPoint, arrowLeft, paint)
      ..drawLine(endPoint, arrowRight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Always repaint the arrow if the delegate changes
    return true;
  }
}
