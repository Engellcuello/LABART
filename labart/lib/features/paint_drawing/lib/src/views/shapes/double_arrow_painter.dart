import 'dart:math';

import 'package:flutter/material.dart';

class DoubleArrowPainter extends CustomPainter {
  DoubleArrowPainter({
    required this.lineColor,
    required this.thickness,
  });
  final Color lineColor;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    const angle = pi * 2;
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Arrow length: 60% of the smaller dimension (width or height)
    final arrowLength = size.width;

    // Starting points for the arrows
    final startPointLeft = Offset(0, size.height / 2);
    final startPointRight = Offset(size.width, size.height / 2);

    // Right arrow end point
    final endPointRight = Offset(
      startPointLeft.dx + arrowLength * cos(angle),
      startPointLeft.dy + arrowLength * sin(angle),
    );

    // Left arrow end point
    final endPointLeft = Offset(
      startPointRight.dx - arrowLength * cos(angle),
      startPointRight.dy - arrowLength * sin(angle),
    );

    // Draw the body of the right arrow
    canvas
      ..drawLine(startPointLeft, endPointRight, paint)
      // Draw the body of the left arrow
      ..drawLine(startPointRight, endPointLeft, paint);

    // Calculate arrowhead size and angle for both arrows
    var headHeight = size.height; // The height of the arrowhead
    //is proportional to the height of the arrow
    const angleOffset = pi / 6; // Angle for the arrowhead

    // Calculate width for the arrowhead
    var headWidth = headHeight * cos(angleOffset);
    if (headWidth > arrowLength / 2.1) {
      // Add 0.1 to prevent the arrows from completely overlapping
      headHeight = arrowLength / 2.1 / cos(angleOffset);
      headWidth = arrowLength;
    }

    // Right arrowhead (left part)
    final arrowRightHeadLeft = Offset(
      endPointRight.dx + headHeight * cos(angle + pi - angleOffset),
      endPointRight.dy + headHeight * sin(angle + pi - angleOffset),
    );
    // Right arrowhead (right part)
    final arrowRightHeadRight = Offset(
      endPointRight.dx + headHeight * cos(angle + pi + angleOffset),
      endPointRight.dy + headHeight * sin(angle + pi + angleOffset),
    );

    // Left arrowhead (left part)
    final arrowLeftHeadLeft = Offset(
      endPointLeft.dx - headHeight * cos(angle + pi - angleOffset),
      endPointLeft.dy - headHeight * sin(angle + pi - angleOffset),
    );
    // Left arrowhead (right part)
    final arrowLeftHeadRight = Offset(
      endPointLeft.dx - headHeight * cos(angle + pi + angleOffset),
      endPointLeft.dy - headHeight * sin(angle + pi + angleOffset),
    );

    // Draw the right arrowhead
    canvas
      ..drawLine(endPointRight, arrowRightHeadLeft, paint)
      ..drawLine(endPointRight, arrowRightHeadRight, paint)
      // Draw the left arrowhead
      ..drawLine(endPointLeft, arrowLeftHeadLeft, paint)
      ..drawLine(endPointLeft, arrowLeftHeadRight, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always redraw
  }
}
