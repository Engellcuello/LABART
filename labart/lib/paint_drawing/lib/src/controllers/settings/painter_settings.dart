import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/settings/brush_settings.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/settings/erase_settings.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/settings/text_settings.dart';

/// A class containing global settings for the painter,
/// including brush and eraser configurations.
class PainterSettings {
  const PainterSettings({
    this.text,
    this.brush,
    this.erase,
    @Deprecated('Use size instead') Size? scale,
    Size? size,
    Color? itemDragHandleColor,
  })  : scale = scale ?? const Size(400, 400),
        size = size ?? const Size(400, 400),
        itemDragHandleColor = itemDragHandleColor ?? Colors.blue;

  /// Settings related to text, such as style and alignment.
  final TextSettings? text;

  /// The default canvas scale size.
  final Size? scale;

  final Size size;

  /// Color of the handles used to drag items on the canvas.
  final Color itemDragHandleColor;

  /// Settings related to the brush tool.
  final BrushSettings? brush;

  /// Settings related to the eraser tool.
  final EraseSettings? erase;
}
