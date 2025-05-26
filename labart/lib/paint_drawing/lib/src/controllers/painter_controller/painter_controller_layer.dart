part of 'painter_controller.dart';

extension PainterControllerLayer on PainterController {
  // updates the layer index for a given painter item
  void updateLayerIndex(PainterItem item, int newIndex) {
    LayerService().updateLayerIndex(
      item,
      newIndex,
      value.items.toList(),
      (items) {
        value = value.copyWith(items: items);
      },
      addAction,
    );
  }

  /// Retrieves the layer index of the specified item.
  int getLayerIndex(PainterItem item) {
    return LayerService().getLayerIndex(item, value.items.toList());
  }
}
