part of 'painter_controller.dart';

extension PainterControllerActions on PainterController {
  // undoes the last action and updates the state
  void undo() {
    ActionsService().undo(
        changeActions, value.paintPaths, value, background.image, (items) {
      value = value.copyWith(items: items);
    }, (index) {
      changeActions.value = changeActions.value.copyWith(index: index);
    }, (pathList) {
      value = value.copyWith(paintPaths: pathList);
    }, (image) {
      background.image = image;
    });
  }

  // redoes the previously undone action and updates the state
  void redo() {
    ActionsService().redo(
        changeActions, value.paintPaths, value, background.image, (items) {
      value = value.copyWith(items: items);
    }, (index) {
      changeActions.value = changeActions.value.copyWith(index: index);
    }, (pathList) {
      value = value.copyWith(paintPaths: pathList);
    }, (image) {
      background.image = image;
    });
  }

  /// Adds an action to the action history and
  /// updates the current change actions.
  void addAction(PaintAction action) {
    ActionsService().addAction(
      action,
      changeActions,
      value,
      (list, index) {
        changeActions.value = changeActions.value.copyWith(
          changeList: list,
          index: index,
        );
      },
    );
  }

  // updates the action by changing the action index and updating the state
  void updateActionWithChangeActionIndex(int index) {
    ActionsService().updateActionWithChangeActionIndex(
        changeActions, value.paintPaths, value, index, background.image,
        (items) {
      value = value.copyWith(items: items);
    }, (index) {
      changeActions.value = changeActions.value.copyWith(index: index);
    }, (pathList) {
      value = value.copyWith(paintPaths: pathList);
    }, (image) {
      background.image = image;
    });
  }
}
