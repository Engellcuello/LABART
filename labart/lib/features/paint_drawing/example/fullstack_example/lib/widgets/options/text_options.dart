import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/options.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';


class TextOptions extends StatelessWidget {
  const TextOptions({required this.controller, required this.item, super.key});
  final PainterController controller;
  final TextItem item;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: listView(
        [
          title('Text Options'),
          fontSize,
          color,
          bgColor,
          textAlign,
          gradient,
        ],
      ),
    );
  }

  Widget get textAlign {
    return Row(
      children: [
        title('Text Align'),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.format_align_left),
          onPressed: () {
            controller.changeTextValues(item, textAlign: TextAlign.left);
          },
        ),
        IconButton(
          icon: const Icon(Icons.format_align_center),
          onPressed: () {
            controller.changeTextValues(item, textAlign: TextAlign.center);
          },
        ),
        IconButton(
          icon: const Icon(Icons.format_align_right),
          onPressed: () {
            controller.changeTextValues(item, textAlign: TextAlign.right);
          },
        ),
      ],
    );
  }

  Widget get fontSize {
    return doubleSwitch(
      'Font Size (${(item.textStyle.fontSize!).toStringAsFixed(0)}px)',
      item.textStyle.fontSize! / 100,
      1,
      (value) {
        controller.changeTextValues(
          item,
          textStyle: item.textStyle.copyWith(fontSize: value * 100),
        );
      },
    );
  }

  Widget get color {
    return colorSwitch(
      'Color',
      item.textStyle.color!,
      (value) {
        controller.changeTextValues(
          item,
          textStyle: item.textStyle.copyWith(
            color:
                Color(value.toInt()).withValues(alpha: item.textStyle.color!.a),
          ),
        );
      },
      opacityCondition: item.enableGradientColor,
    );
  }

  Widget get bgColor {
    return colorSwitch(
      'Background Color',
      item.textStyle.backgroundColor!,
      (value) {
        controller.changeTextValues(
          item,
          textStyle: item.textStyle.copyWith(
            backgroundColor: Color(value.toInt()).withValues(alpha: 1),
          ),
        );
      },
      opacityCondition: item.enableGradientColor,
    );
  }

  Widget get gradient {
    Widget arrow(IconData icon, Alignment begin, Alignment end) {
      return IconButton(
        onPressed: () {
          controller.changeTextValues(
            item,
            gradientBegin: begin,
            gradientEnd: end,
          );
        },
        icon: Icon(
          icon,
          color: Colors.white,
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            title('Gradient'),
            const Spacer(),
            Switch(
              value: item.enableGradientColor,
              onChanged: (value) {
                controller.changeTextValues(
                  item,
                  enableGradientColor: value,
                );
              },
            ),
          ],
        ),
        Column(
          children: [
            colorSwitch(
              'Gradient Start Color',
              item.gradientStartColor,
              (value) {
                controller.changeTextValues(
                  item,
                  gradientStartColor: Color(value.toInt())
                      .withValues(alpha: item.gradientStartColor.a),
                );
              },
              opacityCondition: !item.enableGradientColor,
            ),
            colorSwitch(
              'Gradient End Color',
              item.gradientEndColor,
              (value) {
                controller.changeTextValues(
                  item,
                  gradientEndColor: Color(value.toInt())
                      .withValues(alpha: item.gradientEndColor.a),
                );
              },
              opacityCondition: !item.enableGradientColor,
            ),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  arrow(
                    PhosphorIconsRegular.arrowLeft,
                    Alignment.centerRight,
                    Alignment.centerLeft,
                  ),
                  arrow(
                    PhosphorIconsRegular.arrowRight,
                    Alignment.centerLeft,
                    Alignment.centerRight,
                  ),
                  arrow(
                    PhosphorIconsRegular.arrowUp,
                    Alignment.bottomCenter,
                    Alignment.topCenter,
                  ),
                  arrow(
                    PhosphorIconsRegular.arrowDown,
                    Alignment.topCenter,
                    Alignment.bottomCenter,
                  ),
                  arrow(
                    PhosphorIconsRegular.arrowUpRight,
                    Alignment.bottomLeft,
                    Alignment.topRight,
                  ),
                  arrow(
                    PhosphorIconsRegular.arrowUpLeft,
                    Alignment.bottomRight,
                    Alignment.topLeft,
                  ),
                  arrow(
                    PhosphorIconsRegular.arrowDownRight,
                    Alignment.topLeft,
                    Alignment.bottomRight,
                  ),
                  arrow(
                    PhosphorIconsRegular.arrowDownLeft,
                    Alignment.topRight,
                    Alignment.bottomLeft,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
