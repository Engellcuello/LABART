// ignore_for_file: depend_on_referenced_packages, implementation_imports

import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/pages/result_page.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';

class Layers extends StatelessWidget {
  const Layers({
    required this.controller,
    required this.closeLayers,
    super.key,
  });
  final PainterController controller;
  final void Function() closeLayers;
  @override
  Widget build(BuildContext context) {
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

    Widget section(String title, PainterItem item) {
      return Container(
        height: 40,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey.shade700,
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            const Spacer(),
            iconButton(
              PhosphorIconsRegular.trash,
              Colors.red,
              () {
                controller.removeItem(layerIndex: item.layer.index);
              },
            ),
            iconButton(
              PhosphorIconsRegular.image,
              Colors.blue,
              () async {
                final image =
                    await controller.renderItem(item, enableRotation: true);
                if (image != null && context.mounted) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (context) => ResultPage(image: image),
                    ),
                  );
                }
              },
            ),
            iconButton(
              PhosphorIconsRegular.arrowDown,
              Colors.white,
              () {
                controller.updateLayerIndex(item, item.layer.index - 1);
              },
            ),
            iconButton(
              PhosphorIconsRegular.arrowUp,
              Colors.white,
              () {
                controller.updateLayerIndex(item, item.layer.index + 1);
              },
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      );
    }

    Widget title() {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 10),
        child: Row(
          children: [
            iconButton(Icons.arrow_back_ios, Colors.white, closeLayers),
            const Text(
              'Layers',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 170,
      child: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) => Column(
          children: [
            title(),
            if (value.items.isEmpty)
              SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    'No layers',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 20),
                  ),
                ),
              ),
            if (value.items.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: value.items.length,
                  itemBuilder: (context, index) {
                    return section(
                      value.items[index].layer.title,
                      value.items[index],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
