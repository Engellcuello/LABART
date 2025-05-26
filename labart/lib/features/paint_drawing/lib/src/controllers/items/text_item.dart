import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/settings/layer_settings.dart';
import 'package:labart/features/paint_drawing/lib/src/models/position_model.dart';
import 'package:labart/features/paint_drawing/lib/src/models/size_model.dart';

// Represents a text item that can be drawn on
//a canvas with customizable properties.
class TextItem extends PainterItem {
  // Constructor for initializing the text item with various properties.
  TextItem({
    required this.text, // The text content.
    required super.position, // Position of the text on the canvas.
    required super.layer, // Layer where the text is placed.
    this.textStyle = const TextStyle(
      fontSize: 16, // Default font size.
      color: Colors.black, // Default text color.
      backgroundColor: Colors.transparent, // Default background color for text.
    ),
    this.textAlign = TextAlign.center, // Default text alignment.
    this.enableGradientColor =
        false, // Whether to apply gradient color to the text.
    this.gradientStartColor = Colors.black, // Start color of the gradient.
    this.gradientEndColor = Colors.white, // End color of the gradient.
    this.gradientBegin =
        Alignment.centerLeft, // Start alignment of the gradient.
    this.gradientEnd = Alignment.centerRight, // End alignment of the gradient.
    super.id, // Unique identifier for the text item.
    super.size, // Size of the text item (width and height).
    super.enabled = true, // Whether the text item is enabled or not.
    super.rotation, // Rotation angle of the text.
  });

  final String text; // The text content.
  final TextStyle textStyle; // Text style including font size, color, etc.
  final TextAlign textAlign; // Text alignment (left, center, right).
  final bool
      enableGradientColor; // Whether gradient color is applied to the text.
  final Color gradientStartColor; // Start color of the gradient.
  final Color gradientEndColor; // End color of the gradient.
  final AlignmentGeometry gradientBegin; // Start alignment of the gradient.
  final AlignmentGeometry gradientEnd; // End alignment of the gradient.

  // Method to create a copy of the text item with optional updated properties.
  @override
  TextItem copyWith({
    String? text,
    TextStyle? textStyle,
    TextAlign? textAlign,
    bool? enableGradientColor,
    Color? gradientStartColor,
    Color? gradientEndColor,
    AlignmentGeometry? gradientBegin,
    AlignmentGeometry? gradientEnd,
    PositionModel? position,
    LayerSettings? layer,
    SizeModel? size,
    double? rotation,
    bool? enabled,
  }) {
    return TextItem(
      id: id, // Keep the same ID.
      text: text ?? this.text, // Use provided text or keep the current one.
      textStyle: textStyle ??
          this.textStyle, // Use provided text style or keep the current one.
      textAlign: textAlign ?? this.textAlign, // Use provided text alignment
      ///or keep the current one.
      enableGradientColor: enableGradientColor ??
          this.enableGradientColor, // Use provided gradient flag
      //or keep the current one.
      gradientStartColor: gradientStartColor ??
          this.gradientStartColor, // Use provided gradient start
      //color or keep the current one.
      gradientEndColor: gradientEndColor ??
          this.gradientEndColor, // Use provided gradient end color
      // or keep the current one.
      gradientBegin: gradientBegin ??
          this.gradientBegin, // Use provided gradient start alignment
      //or keep the current one.
      gradientEnd: gradientEnd ??
          this.gradientEnd, // Use provided gradient end alignment or
      // keep the current one.
      position: position ??
          this.position, // Use provided position or keep the current one.
      layer: layer ?? this.layer, // Use provided layer or keep the current one.
      rotation: rotation ??
          this.rotation, // Use provided rotation or keep the current one.
      size: size ?? this.size, // Use provided size or keep the current one.
      enabled: enabled ??
          this.enabled, // Use provided enabled state or keep the current one.
    );
  }
}
