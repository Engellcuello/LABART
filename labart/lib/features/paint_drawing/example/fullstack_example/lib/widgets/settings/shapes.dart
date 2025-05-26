import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';

class Shapes extends StatelessWidget {
  const Shapes({
    required this.controller,
    required this.closeShapes,
    super.key,
  });
  final PainterController controller;
  final void Function() closeShapes;
  @override
  Widget build(BuildContext context) {
    final shapes = [
      {
        'shape': ShapeType.line,
        'title': 'Line',
        'icon': PhosphorIconsRegular.lineVertical,
      },
      {
        'shape': ShapeType.arrow,
        'title': 'Arrow',
        'icon': PhosphorIconsRegular.arrowUpRight,
      },
      {
        'shape': ShapeType.doubleArrow,
        'title': 'Double Arrow',
        'icon': PhosphorIconsRegular.arrowsHorizontal,
      },
      {
        'shape': ShapeType.rectangle,
        'title': 'Rectangle',
        'icon': PhosphorIconsRegular.rectangle,
      },
      {
        'shape': ShapeType.triangle,
        'title': 'Triangle',
        'icon': PhosphorIconsRegular.triangle,
      },
      {
        'shape': ShapeType.star,
        'title': 'Star',
        'icon': PhosphorIconsRegular.star,
      },
      {
        'shape': ShapeType.circle,
        'title': 'Circle',
        'icon': PhosphorIconsRegular.circle,
      },
    ];
    return SizedBox(
      height: 150,
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) => Column(
          children: [
            title,
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: shapes.length,
                itemBuilder: (context, index) {
                  return buttons(
                    shapes[index]['title']! as String,
                    shapes[index]['icon']! as IconData,
                    shapes[index]['shape']! as ShapeType,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttons(String title, IconData icon, ShapeType shape) {
    return GestureDetector(
      onTap: () {
        controller.addShape(shape);
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 5, 6),
        padding: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 30,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget iconButton(IconData icon, Color color, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Icon(
          icon,
          color: color,
          size: 22,
        ),
      ),
    );
  }

  Widget get title {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10),
      child: Row(
        children: [
          iconButton(Icons.arrow_back_ios, Colors.white, closeShapes),
          const Text(
            'Shapes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
