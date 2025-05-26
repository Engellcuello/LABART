import 'dart:typed_data';

/// A class representing the background settings for the painter.
class PainterBackground {
  PainterBackground({
    this.image,
    this.width = 0,
    this.height = 0,
  });

  /// The width of the background.
  final double width;

  /// The height of the background.
  final double height;

  /// The image used as the background, if any.
  Uint8List? image;
}
