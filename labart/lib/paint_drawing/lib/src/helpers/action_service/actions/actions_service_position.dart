part of '../actions_service.dart';

extension ActionsServicePosition on ActionsService {
  // Handles moving an item to a new position during redo/undo actions.
  void _actionPosition(ActionPosition item, bool isRedo) {
    var itemValue = items
        .where(
          (element) => element.id == item.item.id,
        )
        .first;

    // For redo, update the item's position to the new value.
    if (isRedo) {
      itemValue = itemValue.copyWith(position: item.newPosition);
    } else {
      // For undo, revert the item's position to the original value.
      itemValue = itemValue.copyWith(position: item.oldPosition);
    }

    // Update the list with the modified item.
    _updateList(itemValue);
  }
}
