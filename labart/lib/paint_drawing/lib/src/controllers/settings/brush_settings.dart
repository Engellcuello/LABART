import 'package:flutter/material.dart';

/// A class containing settings for the brush tool.
class BrushSettings {
  const BrushSettings({
    required this.color,
    required this.size,
  });

  /// Color of the brush strokes.
  final Color color;

  /// Size of the brush strokes.
  final double size;

  /// Creates a copy of this brush settings with
  /// optional modifications to its properties.
  BrushSettings copyWith({
    Color? color,
    double? size,
  }) {
    return BrushSettings(
      color: color ?? this.color,
      size: size ?? this.size,
    );
  }
}
