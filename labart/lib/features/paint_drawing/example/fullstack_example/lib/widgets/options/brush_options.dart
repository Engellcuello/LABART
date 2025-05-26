import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/options.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';


class BrushOptions extends StatelessWidget {
  const BrushOptions({required this.controller, super.key});
  final PainterController controller;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: listView(
        [
          title('Brush Options'),
          size,
          color,
        ],
      ),
    );
  }

  Widget get size {
    return doubleSwitch(
        'Size (${controller.value.brushSize.toStringAsFixed(0)}px)',
        controller.value.brushSize / 100,
        1, (value) {
      controller.changeBrushValues(
        size: value * 100,
      );
    });
  }

  Widget get color {
    return colorSwitch(
      'Color',
      controller.value.brushColor,
      (value) {
        final intValue = value.toInt();
        controller.changeBrushValues(
          color:
              Color(intValue).withValues(alpha: controller.value.brushColor.a),
        );
      },
    );
  }
}
