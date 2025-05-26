import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/options.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';



class CustomWidgetOptions extends StatelessWidget {
  const CustomWidgetOptions({
    required this.controller,
    required this.item,
    super.key,
  });
  final PainterController controller;
  final CustomWidgetItem item;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: listView(
        [
          title('Custom Widget Options'),
          borderRadius,
          border,
          gradient,
        ],
      ),
    );
  }

  Widget get borderRadius {
    return doubleSwitch(
      'Border Radius',
      item.borderRadius.topLeft.x,
      100,
      (value) {
        final intValue = value.toInt();
        controller.changeCustomWidgetValues(
          item,
          borderRadius: BorderRadius.circular(intValue.toDouble()),
        );
      },
    );
  }

  Widget get border {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        doubleSwitch(
          'Border Width',
          item.borderWidth,
          10,
          (value) {
            final intValue = value.toInt();
            controller.changeCustomWidgetValues(
              item,
              borderWidth: intValue.toDouble(),
            );
          },
        ),
        colorSwitch(
          'Border Color',
          item.borderColor,
          (value) {
            final intValue = value.toInt();
            controller.changeCustomWidgetValues(
              item,
              borderColor:
                  Color(intValue).withValues(alpha: item.borderColor.a),
            );
          },
        ),
      ],
    );
  }

  Widget get gradient {
    Widget arrow(IconData icon, Alignment begin, Alignment end) {
      return IconButton(
        onPressed: () {
          controller.changeCustomWidgetValues(
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
        boolSwitch(
          'Gradient',
          value: item.enableGradientColor,
          onChanged: ({bool? value}) {
            controller.changeCustomWidgetValues(
              item,
              enableGradientColor: value,
            );
          },
        ),
        Opacity(
          opacity: item.enableGradientColor ? 1 : 0.5,
          child: Column(
            children: [
              colorSwitch(
                'Gradient Start Color',
                item.gradientStartColor,
                (value) {
                  final intValue = value.toInt();
                  controller.changeCustomWidgetValues(
                    item,
                    gradientStartColor: Color(intValue)
                        .withValues(alpha: item.gradientStartColor.a),
                  );
                },
              ),
              colorSwitch(
                'Gradient End Color',
                item.gradientEndColor,
                (value) {
                  final intValue = value.toInt();
                  controller.changeCustomWidgetValues(
                    item,
                    gradientEndColor: Color(intValue)
                        .withValues(alpha: item.gradientEndColor.a),
                  );
                },
              ),
              doubleSwitch(
                'Gradient Opacity',
                item.gradientOpacity,
                1,
                (value) {
                  controller.changeCustomWidgetValues(
                    item,
                    gradientOpacity: value,
                  );
                },
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
        ),
      ],
    );
  }
}
