import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/brush_options.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/custom_widget_options.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/erase_options.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/image_options.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/shape_options.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/text_options.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';


class Options extends StatelessWidget {
  const Options({required this.controller, super.key});
  final PainterController controller;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        if (controller.isDrawing) {
          return BrushOptions(controller: controller);
        }
        if (controller.isErasing) {
          return EraseOptions(controller: controller);
        }
        if (value.selectedItem is TextItem) {
          return TextOptions(
            controller: controller,
            item: value.selectedItem! as TextItem,
          );
        } else if (value.selectedItem is ImageItem) {
          return ImageOptions(
            controller: controller,
            item: value.selectedItem! as ImageItem,
          );
        } else if (value.selectedItem is ShapeItem) {
          return ShapeOptions(
            controller: controller,
            item: value.selectedItem! as ShapeItem,
          );
        } else if (value.selectedItem is CustomWidgetItem) {
          return CustomWidgetOptions(
            controller: controller,
            item: value.selectedItem! as CustomWidgetItem,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

Widget listView(List<Widget> children) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        shrinkWrap: true,
        children: children,
      ),
    );

Widget title(String text) => Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );

Widget boolSwitch(
  String text, {
  bool value = false,
  void Function({bool value})? onChanged,
}) {
  return Row(
    children: [
      title(text),
      const Spacer(),
      Switch(
        value: value,
        onChanged: (bool newValue) {
          if (onChanged != null) {
            onChanged(value: newValue);
          }
        },
      ),
    ],
  );
}

Widget colorSwitch(
  String text,
  Color color,
  void Function(double value) onChanged, {
  bool opacityCondition = false,
}) {
  final notifierColor = ValueNotifier<double>(
    (((color.r * 255).toInt() << 16) | // Red kanalını int'e çeviriyoruz
            ((color.g * 255).toInt() << 8) | // Green kanalını int'e çeviriyoruz
            ((color.b * 255).toInt())) // Blue kanalını int'e çeviriyoruz
        .toDouble(),
  );
  return IgnorePointer(
    ignoring: opacityCondition,
    child: Opacity(
      opacity: opacityCondition ? 0.5 : 1,
      child: Row(
        children: [
          title(text),
          const Spacer(),
          ValueListenableBuilder(
            valueListenable: notifierColor,
            builder: (context, colorVal, child) => Slider(
              value: colorVal,
              max: 0xFFFFFF.toDouble(),
              thumbColor: Color(colorVal.toInt()).withValues(alpha: 1),
              onChanged: (value) {
                notifierColor.value = value;
              },
              onChangeEnd: onChanged,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget doubleSwitch(
  String text,
  double doubleValue,
  double maxDoubleValue,
  void Function(double value) onChanged, {
  bool opacityCondition = false,
}) {
  final notifierDouble = ValueNotifier<double>(doubleValue);
  return IgnorePointer(
    ignoring: opacityCondition,
    child: Opacity(
      opacity: opacityCondition ? 0.5 : 1,
      child: Row(
        children: [
          title(text),
          const Spacer(),
          ValueListenableBuilder(
            valueListenable: notifierDouble,
            builder: (context, colorVal, child) => Slider(
              value: colorVal,
              max: maxDoubleValue,
              onChanged: (value) {
                notifierDouble.value = value;
              },
              onChangeEnd: onChanged,
            ),
          ),
        ],
      ),
    ),
  );
}
