import 'package:flutter/material.dart';

/// A class representing text-related settings for customizing text appearance.
class TextSettings {
  const TextSettings({
    this.textStyle,
    this.textAlign,
    this.enableGradientColor,
    this.gradientStartColor,
    this.gradientEndColor,
    this.gradientBegin,
    this.gradientEnd,
  });

  /// Style of the text, including font size, weight, and other properties.
  final TextStyle? textStyle;

  /// Alignment of the text (e.g., left, center, or right).
  final TextAlign? textAlign;

  /// Whether gradient colors are enabled for the text.
  final bool? enableGradientColor;

  /// The starting color of the text gradient.
  final Color? gradientStartColor;

  /// The ending color of the text gradient.
  final Color? gradientEndColor;

  /// The alignment of the gradient's starting point.
  final AlignmentGeometry? gradientBegin;

  /// The alignment of the gradient's ending point.
  final AlignmentGeometry? gradientEnd;
}
