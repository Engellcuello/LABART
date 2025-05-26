import 'dart:ui';

// Model representing a drawing element with an offset, color, and stroke width.
class DrawModel {
  // Constructor to initialize the properties of the DrawModel class.
  DrawModel({
    required this.offset, // The offset (position) of the draw element.
    required this.color, // The color used for drawing.
    required this.strokeWidth, // The width of the stroke for the drawing.
  });

  final Offset offset; // The position of the drawing element on the screen.
  final Color color; // The color of the drawing element.
  final double strokeWidth; // The thickness of the stroke used for drawing.
}
