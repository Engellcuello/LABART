import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/lib/src/models/brush_model.dart';

/// A custom painter class used to render paths, points,
/// and an optional background image on a canvas.
class PainterCustomPaint extends CustomPainter {
  PainterCustomPaint({
    required this.paths,
    required this.points,
    required this.isErasing,
    required this.backgroundImage,
  });

  /// List of paths to be drawn on the canvas.
  final List<List<DrawModel?>> paths;

  /// Current points being drawn by the user, forming a temporary path.
  final List<DrawModel?> points;

  /// Indicates whether the eraser tool is active.
  final bool isErasing;

  /// The optional background image to be displayed behind the drawings.
  final ui.Image? backgroundImage;

  @override
  void paint(Canvas canvas, Size size) {
    // Creates a paint object with the specified color and stroke width.
    Paint paint(Color color, double strokeWidth) {
      return Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth;
    }

    // Paint object for the background color.
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    // Defines the area to be painted as the canvas size.
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // Draws the background image if available.
    if (backgroundImage != null) {
      canvas.drawImageRect(
        backgroundImage!,
        Rect.fromLTWH(
          0,
          0,
          backgroundImage!.width.toDouble(),
          backgroundImage!.height.toDouble(),
        ),
        rect,
        Paint(),
      );
    } else {
      // Paints a white rectangle as the background.
      canvas.drawRect(rect, backgroundPaint);
    }

    // Draws all the paths stored in the paths list.
    for (final path in paths) {
      if (path.isEmpty) continue;

      for (var i = 0; i < path.length - 1; i++) {
        if (path[i] != null && path[i + 1] != null) {
          canvas.drawLine(
            path[i]!.offset,
            path[i + 1]!.offset,
            paint(path[i]!.color, path[i]!.strokeWidth),
          );
        }
      }
    }

    // Draws the user's current temporary path.
    for (var i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(
          points[i]!.offset,
          points[i + 1]!.offset,
          paint(points[i]!.color, points[i]!.strokeWidth),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Always repaints the canvas whenever an update is made.
    return true;
  }
}
