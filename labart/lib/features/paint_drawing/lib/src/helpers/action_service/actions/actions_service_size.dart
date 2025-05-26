part of '../actions_service.dart';

extension ActionsServiceSize on ActionsService {
  // Handles resizing an item and updating its position during redo/undo actions.
  void _actionSize(ActionSize item, bool isRedo) {
    var itemValue = items
        .where(
          (element) => element.id == item.item.id,
        )
        .first;

    // For redo, update the item's size and position to the new values.
    if (isRedo) {
      itemValue = itemValue.copyWith(
        size: item.newSize,
        position: item.newPosition,
      );
    } else {
      // For undo, revert the item's size and position to the original values.
      itemValue = itemValue.copyWith(
        size: item.oldSize,
        position: item.oldPosition,
      );
    }

    // Update the list with the modified item.
    _updateList(itemValue);
  }
}
