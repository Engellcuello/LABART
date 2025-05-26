import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/widgets/options/options.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';


class ImageOptions extends StatelessWidget {
  const ImageOptions({required this.controller, required this.item, super.key});
  final PainterController controller;
  final ImageItem item;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: listView(
        [
          title('Image Options'),
          fit,
          borderRadius,
          border,
          gradient,
        ],
      ),
    );
  }

  Widget get fit {
    Widget button(String text, BoxFit fit) {
      return GestureDetector(
        onTap: () {
          controller.changeImageValues(item, boxFit: fit);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 5, top: 5),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey),
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Wrap(
      children: [
        title('Fit'),
        button('Contain', BoxFit.contain),
        button('Cover', BoxFit.cover),
        button('Fill', BoxFit.fill),
        button('Fit Width', BoxFit.fitWidth),
        button('Fit Height', BoxFit.fitHeight),
        button('None', BoxFit.none),
        button('Scale Down', BoxFit.scaleDown),
      ],
    );
  }

  Widget get borderRadius {
    return doubleSwitch('Border Radius', item.borderRadius.topLeft.x, 100,
        (value) {
      final intValue = value.toInt();
      controller.changeImageValues(
        item,
        borderRadius: BorderRadius.circular(intValue.toDouble()),
      );
    });
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
            controller.changeImageValues(
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
            controller.changeImageValues(
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
          controller.changeImageValues(
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
            controller.changeImageValues(
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
                  controller.changeImageValues(
                    item,
                    gradientStartColor: Color(intValue)
                        .withValues(alpha: item.gradientStartColor.a),
                  );
                },
                opacityCondition: !item.enableGradientColor,
              ),
              colorSwitch(
                'Gradient End Color',
                item.gradientEndColor,
                (value) {
                  final intValue = value.toInt();
                  controller.changeImageValues(
                    item,
                    gradientEndColor: Color(intValue)
                        .withValues(alpha: item.gradientEndColor.a),
                  );
                },
                opacityCondition: !item.enableGradientColor,
              ),
              doubleSwitch('Gradient Opacity', item.gradientOpacity, 1,
                  (value) {
                controller.changeImageValues(
                  item,
                  gradientOpacity: value,
                );
              }),
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
