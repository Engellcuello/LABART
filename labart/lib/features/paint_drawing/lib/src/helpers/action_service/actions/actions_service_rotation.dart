part of '../actions_service.dart';

extension ActionsServiceRotation on ActionsService {
  // Handles rotation actions during redo/undo operations.
  void _actionRotation(ActionRotation item, bool isRedo) {
    // Find the item in the list using its ID.
    var itemValue = items
        .where(
          (element) => element.id == item.item.id,
        )
        .first;

    // If it's a redo, apply the new rotation angle.
    if (isRedo) {
      itemValue = itemValue.copyWith(rotation: item.newRotateAngle);
    } else {
      // If it's an undo, revert to the old rotation angle.
      itemValue = itemValue.copyWith(rotation: item.oldRotateAngle);
    }

    // Update the list with the modified item.
    _updateList(itemValue);
  }
}
