part of '../painter_controller.dart';

extension PainterControllerItems on PainterController {
  /// Updates the position of an item in the items list at the specified index.
  void setItemPosition(int index, PositionModel position) {
    final items = value.items.toList();
    var item = items[index];
    if (item is TextItem) {
      item = item.copyWith(position: position);
    } else {
      item = item.copyWith(position: position);
    }
    items
      ..removeAt(index)
      ..insert(index, item);
    value = value.copyWith(items: items);
  }

  /// Updates the rotation of an item in the items list at the specified index.
  void setItemRotation(int index, double rotation) {
    final items = value.items.toList();
    var item = items[index];
    if (item is TextItem) {
      item = item.copyWith(rotation: rotation);
    } else {
      item = item.copyWith(rotation: rotation);
    }
    items
      ..removeAt(index)
      ..insert(index, item);
    value = value.copyWith(items: items);
  }

  /// Updates the size of an item in the items list at the specified index.
  void setItemSize(int index, SizeModel size) {
    final items = value.items.toList();
    var item = items[index];
    if (item is TextItem) {
      item = item.copyWith(size: size);
    } else {
      item = item.copyWith(size: size);
    }
    items
      ..removeAt(index)
      ..insert(index, item);
    value = value.copyWith(items: items);
  }

  // removes a painter item from the list based on layer index or selected item
  void removeItem({int? layerIndex}) {
    if (value.selectedItem == null && layerIndex == null) return;
    final itemsReversed = value.items.reversed.toList();
    var index = 0;
    if (layerIndex != null && layerIndex < itemsReversed.length + 1) {
      index = layerIndex;
    } else {
      index =
          value.items.length - 1 - _getItemIndexFromItem(value.selectedItem!);
    }
    if (index < 0) return;
    final item = itemsReversed[index];
    itemsReversed.removeAt(index);
    for (var i = index; i < itemsReversed.length; i++) {
      itemsReversed[i] = itemsReversed[i].copyWith(
        layer: itemsReversed[i].layer.copyWith(index: i),
      );
    }
    value = value.copyWith(items: itemsReversed.reversed.toList());
    addAction(
      ActionRemoveItem(
        item: item,
        listIndex: index,
        timestamp: DateTime.now(),
        actionType: ActionType.removedItem,
      ),
    );
    clearSelectedItem();
  }

  // clears the selected item in the canvas
  void clearSelectedItem() {
    value.selectedItem = null;
    value = value.copyWith();
  }

  // retrieves the index of a given painter item
  int _getItemIndexFromItem(PainterItem item) {
    final index = value.items.indexWhere((element) => element.id == item.id);
    return index;
  }
}
