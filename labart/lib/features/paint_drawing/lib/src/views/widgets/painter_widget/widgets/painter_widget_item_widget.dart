part of '../painter_widget.dart';

class PainterWidgetItemWidget extends StatelessWidget {
  const PainterWidgetItemWidget({
    required this.item,
    required this.controller,
    super.key,
  });
  final PainterItem item;
  final PainterController controller;

  @override
  Widget build(BuildContext context) {
    // Check if the item is a TextItem
    if (item is TextItem) {
      return PainterWidgetTextItem(
        item: item as TextItem,
        controller: controller,
      );
    }
    // Check if the item is an ImageItem
    else if (item is ImageItem) {
      return PainterWidgetImageItem(
        item: item as ImageItem,
        controller: controller,
      );
    }
    // Check if the item is a ShapeItem
    else if (item is ShapeItem) {
      return PainterWidgetShapeItem(
        item: item as ShapeItem,
        controller: controller,
      );
    }
    // Check if the item is a CustomWidgetItem
    else if (item is CustomWidgetItem) {
      return PainterWidgetCustomWidgetItem(
        item: item as CustomWidgetItem,
        controller: controller,
      );
    }
    // If the item type is not recognized, return an empty container
    else {
      return const SizedBox.shrink();
    }
  }
}
