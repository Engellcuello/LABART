import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';

/// A class representing settings for shapes drawn on the canvas.
class ShapeSettings {
  const ShapeSettings({
    this.shapeType,
    this.backgroundColor,
    this.lineColor,
    this.thickness,
  });

  /// The type of shape (e.g., circle, rectangle).
  final ShapeType? shapeType;

  /// Background color of the shape.
  final Color? backgroundColor;

  /// Line color of the shape's border.
  final Color? lineColor;

  /// Thickness of the shape's border.
  final double? thickness;
}
