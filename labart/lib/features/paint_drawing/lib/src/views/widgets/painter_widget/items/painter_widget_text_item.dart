part of '../painter_widget.dart';

class PainterWidgetTextItem extends StatelessWidget {
  const PainterWidgetTextItem({
    required this.item,
    required this.controller,
    super.key,
  });
  final TextItem item;
  final PainterController controller;
  @override
  Widget build(BuildContext context) {
    return TextItemWidget(
      item: item,
      height: controller.background.height,
      canvasSize: controller.value.settings.size,
      painterController: controller,
      onPositionChange: (position) {
        // When the position or size changes, the old item comes back.
        // To prevent an error when the index is not
        //found, we search for the item
        // through its size and get the index based on it.
        final newItem = controller.value.items.firstWhere(
          (element) => element.id == item.id,
        );
        final itemIndex = controller.value.items.indexOf(newItem);
        controller.setItemPosition(itemIndex, position);
      },
      onRotationChange: (rotation) {
        // When the position or size changes, the old item comes back.
        // To prevent an error when the index is not
        //found, we search for the item
        // through its size and get the index based on it.
        final newItem = controller.value.items.firstWhere(
          (element) => element.id == item.id,
        );
        final itemIndex = controller.value.items.indexOf(newItem);
        controller.setItemRotation(itemIndex, rotation);
      },
      onSizeChange: (position, size) {
        // When the position or size changes, the old item comes back.
        // To prevent an error when the index is not
        //found, we search for the item
        // through its size and get the index based on it.
        final newItem = controller.value.items.firstWhere(
          (element) => element.id == item.id,
          orElse: () => item,
        );
        final itemIndex = controller.value.items.indexOf(newItem);
        controller
          ..setItemSize(itemIndex, size)
          ..setItemPosition(itemIndex, position);
      },
      onTapItem: () => controller.triggerEvent(
        ItemPressEvent(
          item: item,
          layerIndex: controller.getLayerIndex(item),
        ),
      ),
    );
  }
}
