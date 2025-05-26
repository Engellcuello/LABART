part of '../actions_service.dart';

extension ActionsServiceAction on ActionsService {
  // Adds a new action to the list of actions and updates the actions history.
  void addAction(
    PaintAction action,
    ValueNotifier<PaintActions> changeActions,
    PainterControllerValue value,
    void Function(List<PaintAction>? items, int index) updatedValues,
  ) {
    // Set values before adding the new action.
    _setValues(changeActions, currentPaintPath, value, backgroundImage);

    // If we're not at the end of the action
    //history, trim the redo actions before adding the new action.
    if (changeActions.value.index < changeActions.value.changeList.length - 1) {
      changeActions.value = changeActions.value.copyWith(
        changeList: changeActions.value.changeList
            .sublist(0, changeActions.value.index + 1),
        index: changeActions.value.index + 1,
      );
    }
    // Add the new action to the history and update the state.
    changeActions.value = changeActions.value.copyWith(
      changeList: changeActions.value.changeList.toList()..add(action),
      index: changeActions.value.changeList.length,
    );

    // Update the values with the new action.
    updatedValues(
      changeActions.value.changeList,
      changeActions.value.changeList.length - 1,
    );
  }
}
