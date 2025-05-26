import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/custom_paint.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/models/brush_model.dart';
import 'package:labart/features/paint_drawing/lib/src/views/widgets/items/custom_widget_item_widget.dart';
import 'package:labart/features/paint_drawing/lib/src/views/widgets/items/image_item_widget.dart';
import 'package:labart/features/paint_drawing/lib/src/views/widgets/items/shape_item_widget.dart';
import 'package:labart/features/paint_drawing/lib/src/views/widgets/items/text_item_widget.dart';
part 'widgets/painter_widget_item_widget.dart';
part 'widgets/painter_widget_drawing_widget.dart';
part 'widgets/painter_widget_main_widget.dart';
part 'widgets/painter_widget_viewer_widget.dart';
part 'widgets/painter_widget_pan_gesture_detector_widget.dart';
part 'items/painter_widget_image_item.dart';
part 'items/painter_widget_shape_item.dart';
part 'items/painter_widget_text_item.dart';
part 'items/painter_widget_custom_widget_item.dart';

// A StatelessWidget that listens to changes in
//the PainterController and rebuilds its child
//widget when the controller's value changes.
class PainterWidget extends StatelessWidget {
  // Constructor for the PainterWidget, which
  //requires a PainterController instance.
  const PainterWidget({
    required this.controller,
    this.boundaryMargin,
    super.key,
  });

  // The PainterController that manages the painting logic and state.
  final PainterController controller;
  final double? boundaryMargin;
  // Builds the widget tree by listening to
  //changes in the PainterController's value.
  @override
  Widget build(BuildContext context) {
    // A ValueListenableBuilder listens to
    //changes in the controller and rebuilds the widget when the value changes.
    return ValueListenableBuilder<PainterControllerValue>(
      valueListenable: controller, // The controller is the value to listen to.
      builder: (context, value, child) {
        // Builds and returns the _ViewerWidget, which likely
        //renders the painting or drawing based on the controller's state.
        return _ViewerWidget(
          controller: controller,
          boundaryMargin: boundaryMargin,
        );
      },
    );
  }
}
