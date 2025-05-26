import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/options.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';


class EraseOptions extends StatelessWidget {
  const EraseOptions({required this.controller, super.key});
  final PainterController controller;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: listView(
        [
          title('Erase Options'),
          size,
        ],
      ),
    );
  }

  Widget get size {
    return doubleSwitch(
      'Size (${(controller.value.brushSize / 100).toStringAsFixed(0)}px)',
      controller.value.brushSize / 100,
      1,
      (value) {
        controller.changeBrushValues(
          size: value * 100,
        );
      },
    );
  }
}
