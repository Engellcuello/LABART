import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/settings/layer_settings.dart';
import 'package:labart/features/paint_drawing/lib/src/models/position_model.dart';
import 'package:labart/features/paint_drawing/lib/src/models/size_model.dart';

// Represents an image item that can be added to the canvas in the painter tool.
class CustomWidgetItem extends PainterItem {
  CustomWidgetItem({
    required this.widget, // The child widget.
    required super.position, // The position of the image on the canvas.
    required super.layer, // The layer settings for the image.
    this.enableGradientColor = false, // Determines if a gradient
    //color overlay is applied to the image.
    this.gradientStartColor = Colors.black, // The start color of the gradient.
    this.gradientEndColor = Colors.white, // The end color of the gradient.
    this.gradientBegin =
        Alignment.centerLeft, // The alignment for the start of the gradient.
    this.gradientEnd =
        Alignment.centerRight, // The alignment for the end of the gradient.
    this.gradientOpacity = 0.5, // The opacity of the gradient overlay.
    this.borderRadius =
        BorderRadius.zero, // The border radius for the image container.
    this.borderColor =
        Colors.black, // The color of the border around the image.
    this.borderWidth = 0.0, // The width of the border around the image.
    super.id, // Unique identifier for the image item.
    super.size, // The size of the image item.
    super.enabled =
        true, // Indicates if the image is enabled (visible and active).
    super.rotation, // The rotation angle of the image in degrees.
  });

  final Widget widget; // The actual child widget.
  final bool
      enableGradientColor; // If true, applies a gradient overlay to the image.
  final Color gradientStartColor; // Gradient start color.
  final Color gradientEndColor; // Gradient end color.
  final AlignmentGeometry gradientBegin; // Starting alignment for the gradient.
  final AlignmentGeometry gradientEnd; // Ending alignment for the gradient.
  final double gradientOpacity; // Opacity value for the gradient overlay.
  final BorderRadius borderRadius; // Border radius for the image container.
  final Color borderColor; // Color of the image border.
  final double borderWidth; // Width of the image border.

  @override
  CustomWidgetItem copyWith({
    Widget? widget, // New image data, if provided.
    TextStyle? textStyle, // New text style, if provided.
    TextAlign? textAlign, // New text alignment, if provided.
    bool? enableGradientColor, // New gradient enable setting, if provided.
    Color? gradientStartColor, // New gradient start color, if provided.
    Color? gradientEndColor, // New gradient end color, if provided.
    AlignmentGeometry?
        gradientBegin, // New gradient start alignment, if provided.
    AlignmentGeometry? gradientEnd, // New gradient end alignment, if provided.
    double? gradientOpacity, // New gradient opacity, if provided.
    PositionModel? position, // New position, if provided.
    BoxFit? fit, // New fit setting, if provided.
    BorderRadius? borderRadius, // New border radius, if provided.
    Color? borderColor, // New border color, if provided.
    double? borderWidth, // New border width, if provided.
    LayerSettings? layer, // New layer settings, if provided.
    SizeModel? size, // New size, if provided.
    double? rotation, // New rotation angle, if provided.
    bool? enabled, // New enabled state, if provided.
  }) {
    return CustomWidgetItem(
      id: id,
      widget: widget ?? this.widget,
      enableGradientColor: enableGradientColor ?? this.enableGradientColor,
      gradientStartColor: gradientStartColor ?? this.gradientStartColor,
      gradientEndColor: gradientEndColor ?? this.gradientEndColor,
      gradientBegin: gradientBegin ?? this.gradientBegin,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      gradientOpacity: gradientOpacity ?? this.gradientOpacity,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      position: position ?? this.position,
      layer: layer ?? this.layer,
      rotation: rotation ?? this.rotation,
      size: size ?? this.size,
      enabled: enabled ?? this.enabled,
    );
  }
}
