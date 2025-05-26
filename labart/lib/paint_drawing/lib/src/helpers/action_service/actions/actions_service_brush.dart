part of '../actions_service.dart';

extension ActionsServiceBrush on ActionsService {
  // Handles drawing actions during redo/undo operations.
  void _actionDraw(ActionDraw item, bool isRedo) {
    // If it's a redo, insert the drawn path at the specified index.
    if (isRedo) {
      currentPaintPath.insert(item.listIndex, item.paintPath);
    } else {
      // If it's an undo, remove the drawn path at the specified index.
      currentPaintPath.removeAt(item.listIndex);
    }
  }

  // Handles erase actions during redo/undo operations.
  void _actionErese(ActionErase item, bool isRedo) {
    // If it's a redo, restore the current paint path.
    if (isRedo) {
      currentPaintPath = item.currentPaintPath;
    } else {
      // If it's an undo, restore the last paint path.
      currentPaintPath = item.lastPaintPath;
    }
  }
}
