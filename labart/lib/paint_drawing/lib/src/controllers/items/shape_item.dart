import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/settings/layer_settings.dart';

// Represents a shape item (e.g., circle, rectangle)
//that can be drawn on a canvas.
class ShapeItem extends PainterItem {
  // Constructor for initializing the shape item with various properties.
  ShapeItem({
    required super.position, // Position of the shape on the canvas.
    required super.layer, // Layer where the shape is placed.
    required this.shapeType, // Type of the shape (circle, rectangle, etc.).
    this.backgroundColor = Colors.transparent, // Background color of the shape.
    this.lineColor = Colors.black, // Color of the shape's border/line.
    this.thickness = 2, // Thickness of the shape's border/line.
    super.id, // Unique identifier for the shape item.
    super.size, // Size of the shape (width and height).
    super.enabled = true, // Whether the shape is enabled or not.
    super.rotation, // Rotation angle of the shape.
  });

  final ShapeType shapeType; // Type of the shape (e.g., Circle, Rectangle).
  final Color backgroundColor; // Background color of the shape.
  final Color lineColor; // Color of the shape's border.
  final double thickness; // Thickness of the shape's border.

  // Method to create a copy of the shape item with optional updated properties.
  @override
  ShapeItem copyWith({
    PositionModel? position,
    LayerSettings? layer,
    ShapeType? shapeType,
    Color? backgroundColor,
    Color? lineColor,
    double? thickness,
    SizeModel? size,
    double? rotation,
    bool? enabled,
  }) {
    return ShapeItem(
      id: id, // Keep the same ID.
      position: position ??
          this.position, // Use provided position or keep the current one.
      layer: layer ?? this.layer, // Use provided layer or keep the current one.
      shapeType: shapeType ??
          this.shapeType, // Use provided shape type or keep the current one.
      backgroundColor: backgroundColor ??
          this.backgroundColor, // Use provided background color
      //or keep the current one.
      lineColor: lineColor ??
          this.lineColor, // Use provided line color or keep the current one.
      thickness: thickness ??
          this.thickness, // Use provided thickness or keep the current one.
      rotation: rotation ??
          this.rotation, // Use provided rotation or keep the current one.
      size: size ?? this.size, // Use provided size or keep the current one.
      enabled: enabled ??
          this.enabled, // Use provided enabled state or keep the current one.
    );
  }

  // Method to get the default size based on the shape type.
  static SizeModel defaultSize(ShapeType type) {
    if (type == ShapeType.line ||
        type == ShapeType.arrow ||
        type == ShapeType.doubleArrow) {
      return const SizeModel(
        width: 100,
        height: 30,
      ); // Default size for line-based shapes.
    } else {
      return const SizeModel(
        width: 100,
        height: 100,
      ); // Default size for other shapes.
    }
  }
}
