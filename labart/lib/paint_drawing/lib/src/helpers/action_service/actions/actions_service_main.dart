part of '../actions_service.dart';

extension ActionsServiceMain on ActionsService {
  // Updates actions by determining whether to undo or
  //redo and applies the corresponding actions.

  void updateActionWithChangeActionIndex(
    ValueNotifier<PaintActions> changeActions,
    List<List<DrawModel?>> paintPath,
    PainterControllerValue value,
    int index,
    Uint8List? backgroundImageValue,
    void Function(List<PainterItem> items) updatedList,
    void Function(int index) updateIndex,
    void Function(List<List<DrawModel?>> pathList) updatedPaintPath,
    void Function(Uint8List? image) updateBackgroundImage,
  ) {
    // Set the values before performing any action.
    _setValues(changeActions, paintPath, value, backgroundImage);

    // Function to undo actions from the current
    // index back to the specified index.
    void undoActions() {
      for (var i = currentIndex; i > index; i--) {
        if (currentActions[i] is ActionAddItem) {
          _actionAddItem(currentActions[i] as ActionAddItem, false);
        }
        if (currentActions[i] is ActionPosition) {
          _actionPosition(currentActions[i] as ActionPosition, false);
        } else if (currentActions[i] is ActionSize) {
          _actionSize(currentActions[i] as ActionSize, false);
        } else if (currentActions[i] is ActionRotation) {
          _actionRotation(currentActions[i] as ActionRotation, false);
        } else if (currentActions[i] is ActionLayerChange) {
          _actionLayerChange(currentActions[i] as ActionLayerChange, false);
        } else if (currentActions[i] is ActionRemoveItem) {
          _actionRemoveItem(currentActions[i] as ActionRemoveItem, false);
        } else if (currentActions[i] is ActionDraw) {
          _actionDraw(currentActions[i] as ActionDraw, false);
        } else if (currentActions[i] is ActionErase) {
          _actionErese(currentActions[i] as ActionErase, false);
        } else if (currentActions[i] is ActionTextChangeValue ||
            currentActions[i] is ActionImageChangeValue ||
            currentActions[i] is ActionShapeChangeValue ||
            currentActions[i] is ActionCustomWidgetChangeValue) {
          _actionChangeValue(currentActions[i], false);
        } else if (currentActions[i] is ActionChangeBackgroundImage) {
          _actionBackgroundImageChange(
            currentActions[i] as ActionChangeBackgroundImage,
            false,
          );
        }
      }
    }

    // Function to redo actions from the current index to the specified index.
    void redoActions() {
      for (var i = currentIndex + 1; i <= index; i++) {
        if (currentActions[i] is ActionAddItem) {
          _actionAddItem(currentActions[i] as ActionAddItem, true);
        }
        if (currentActions[i] is ActionPosition) {
          _actionPosition(currentActions[i] as ActionPosition, true);
        } else if (currentActions[i] is ActionSize) {
          _actionSize(currentActions[i] as ActionSize, true);
        } else if (currentActions[i] is ActionRotation) {
          _actionRotation(currentActions[i] as ActionRotation, true);
        } else if (currentActions[i] is ActionLayerChange) {
          _actionLayerChange(currentActions[i] as ActionLayerChange, true);
        } else if (currentActions[i] is ActionRemoveItem) {
          _actionRemoveItem(currentActions[i] as ActionRemoveItem, true);
        } else if (currentActions[i] is ActionDraw) {
          _actionDraw(currentActions[i] as ActionDraw, true);
        } else if (currentActions[i] is ActionErase) {
          _actionErese(currentActions[i] as ActionErase, true);
        } else if (currentActions[i] is ActionTextChangeValue ||
            currentActions[i] is ActionImageChangeValue ||
            currentActions[i] is ActionShapeChangeValue ||
            currentActions[i] is ActionCustomWidgetChangeValue) {
          _actionChangeValue(currentActions[i], true);
        } else if (currentActions[i] is ActionChangeBackgroundImage) {
          _actionBackgroundImageChange(
            currentActions[i] as ActionChangeBackgroundImage,
            true,
          );
        }
      }
    }

    // Decide whether to undo or redo actions based on the provided index.
    if (index < currentIndex) {
      undoActions();
    } else {
      redoActions();
    }

    // Update the list, index, and paint path after performing the actions.
    updatedList(items);
    updateIndex(index);
    updatedPaintPath(currentPaintPath);
    if (backgroundImage != backgroundImageValue) {
      updateBackgroundImage(backgroundImage);
    }
  }

  // Handles undo operations by updating
  //the state and applying the previous action.
  void undo(
    ValueNotifier<PaintActions> changeActions,
    List<List<DrawModel?>> paintPath,
    PainterControllerValue value,
    Uint8List? backgroundImageValue,
    void Function(List<PainterItem> items) updatedList,
    void Function(int index) updateIndex,
    void Function(List<List<DrawModel?>> pathList) updatedPaintPath,
    void Function(Uint8List? image) updateBackgroundImage,
  ) {
    // Set the values for the current action state.
    _setValues(changeActions, paintPath, value, backgroundImageValue);

    // If there are no actions to undo, return early.
    if (currentIndex < 0) return;

    // Apply the previous action (one step back)
    //and update the list and paint path.
    updateActionWithChangeActionIndex(
      changeActions,
      currentPaintPath,
      value,
      currentIndex - 1,
      backgroundImage,
      updatedList,
      updateIndex,
      updatedPaintPath,
      updateBackgroundImage,
    );
  }

  // Handles redo operations by updating the state and applying the next action.
  void redo(
    ValueNotifier<PaintActions> changeActions,
    List<List<DrawModel?>> paintPath,
    PainterControllerValue value,
    Uint8List? backgroundImageValue,
    void Function(List<PainterItem> items) updatedList,
    void Function(int index) updateIndex,
    void Function(List<List<DrawModel?>> pathList) updatedPaintPath,
    void Function(Uint8List? image) updateBackgroundImage,
  ) {
    // Set the values for the current action state.
    _setValues(changeActions, paintPath, value, backgroundImageValue);

    // If there are no actions to redo, return early.
    if (currentIndex == currentActions.length - 1) return;

    // Apply the next action (one step forward)
    //and update the list and paint path.
    updateActionWithChangeActionIndex(
      changeActions,
      currentPaintPath,
      value,
      currentIndex + 1,
      backgroundImage,
      updatedList,
      updateIndex,
      updatedPaintPath,
      updateBackgroundImage,
    );
  }

  // Updates the item in the list after an action.
  void _updateList(PainterItem item) {
    // Find the index of the item to update.
    final itemIndex = items.indexWhere((element) {
      return element.id == item.id;
    });

    // Remove the old item and insert the updated one.
    items
      ..removeAt(itemIndex)
      ..insert(itemIndex, item);
  }

  // Handles adding an item to the list of items during redo/undo actions.
  void _actionAddItem(ActionAddItem item, bool isRedo) {
    if (isRedo) {
      // For redo, add the item back to the list at the specified index.
      _addItem(item.item, items.length - item.listIndex);
    } else {
      // For undo, remove the item from the list.
      final itemValue = items
          .where(
            (element) => element.id == item.item.id,
          )
          .first;
      _removeItemFromList(itemValue.id);
    }
  }

  // Handles item removal actions during redo/undo operations.
  void _actionRemoveItem(ActionRemoveItem item, bool isRedo) {
    // If it's a redo, remove the item from the list.
    if (isRedo) {
      _removeItemFromList(item.item.id);
    } else {
      // If it's an undo, add the item back to the list at the specified index.
      _addItem(item.item, items.length - item.listIndex);
    }
  }

  // Removes an item from the list based on its ID.
  void _removeItemFromList(String itemId) {
    // Find the index of the item to remove.
    final itemIndex = items.indexWhere(
      (element) => element.id == itemId,
    );
    // Find and remove the item with the matching ID.
    items.removeWhere((element) => element.id == itemId);

    _checkLayerIndex(itemIndex);
  }
}
