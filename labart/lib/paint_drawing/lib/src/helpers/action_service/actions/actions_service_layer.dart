part of '../actions_service.dart';

extension ActionsServiceLayer on ActionsService {
  void _checkLayerIndex(int index) {
    // Adjust the layer index of the items between
    //oldIndex and newIndex.
    if (index < items.length) {
      // If the item moved down, update the layer index
      //of items between oldIndex and newIndex.
      for (var i = index; i < items.length; i++) {
        items[i] = items[i].copyWith(
          layer: items[i].layer.copyWith(index: items.length - 1 - i),
        );
      }
    }
  }

// Handles layer change actions during redo/undo operations.
  void _actionLayerChange(ActionLayerChange item, bool isRedo) {
    // Find the item and changed item in the list using their IDs.
    final itemValue = items.firstWhere(
      (element) => element.id == item.item.id,
    );
    final changedItem = items.firstWhere(
      (element) => element.id == item.changedItem.id,
    );

    // Compute adjusted indices to account for the reversed logic.
    final itemNewIndex = items.length - 1 - item.newIndex;
    final changedItemNewIndex = items.length - 1 - item.changedItemNewIndex;
    final itemOldIndex = items.length - 1 - item.oldIndex;
    final changedItemOldIndex = items.length - 1 - item.changedItemOldIndex;

    // If it's a redo, move the items to the new positions in the list.
    if (isRedo) {
      _removeItemFromList(itemValue.id);
      _addItem(itemValue, itemNewIndex.clamp(0, items.length));
      _removeItemFromList(changedItem.id);
      _addItem(changedItem, changedItemNewIndex);
    } else {
      // If it's an undo, move the items back to their original positions.
      _removeItemFromList(itemValue.id);
      _addItem(itemValue, itemOldIndex);
      _removeItemFromList(changedItem.id);
      _addItem(changedItem, changedItemOldIndex);
    }
  }
}
