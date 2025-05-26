import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/layer/layer_change_action.dart';

class LayerService {
  // A list to store PainterItem objects representing layers.
  List<PainterItem> items = [];

  // Updates the layer index of a specific PainterItem and handles reordering.
  void updateLayerIndex(
    PainterItem item, // The item whose layer index is being updated.
    int newIndex, // The new index for the item.
    List<PainterItem> itemList, // The list of items to be updated.
    void Function(List<PainterItem>)
        changedList, // Callback function to update the list.
    void Function(ActionLayerChange action)
        changeAction, // Callback function for the change action.
  ) {
    // Set the values from the itemList to the service's items list.
    _setValues(itemList);

    // Reverse the items list to handle the reversed order.
    items = items.reversed.toList();

    // Get the current index of the item to be moved.
    final oldIndex = items.indexOf(item);

    // Remove the item from its old position.
    items.removeAt(oldIndex);

    // Create a new item with the updated layer index.
    final updatedItem =
        item.copyWith(layer: item.layer.copyWith(index: newIndex));

    // Ensure the new index is valid by clamping it between 0
    //and the length of the items list.
    final validIndex = newIndex.clamp(0, items.length);
    // Insert the updated item at the new index.
    items.insert(validIndex, updatedItem);

    // Get the item that was changed.
    final changedItem = items[oldIndex];
    // Adjust the layer index of the items between
    //oldIndex and newIndex.
    if (oldIndex < newIndex) {
      if (newIndex >= items.length) {
        return;
      }
      // If the item moved down, update the layer index
      //of items between oldIndex and newIndex.
      for (var i = oldIndex; i < newIndex; i++) {
        items[i] = items[i].copyWith(layer: items[i].layer.copyWith(index: i));
      }
    } else {
      if (newIndex < 0) {
        return;
      }
      // If the item moved up, update the layer index of
      //items between newIndex and oldIndex.
      for (var i = newIndex + 1; i <= oldIndex; i++) {
        items[i] = items[i].copyWith(layer: items[i].layer.copyWith(index: i));
      }
    }

    // Reverse the items list back to its original order.
    items = items.reversed.toList();

    // Call the callback functions with the updated list and action.
    changedList(items);
    // Generate and pass the action for the layer change.
    changeAction(
      _getChangeAction(
        item, // The item whose layer was changed.
        oldIndex, // The old index of the item.
        validIndex, // The new index of the item.
        changedItem, // The updated item after the change.
        validIndex, // The old index of the changed item.
        oldIndex, // The new valid index of the changed item.
      ),
    );
  }

  // Returns the layer index of the given item in the provided item list.
  int getLayerIndex(
    PainterItem item, // The item whose layer index is being queried.
    List<PainterItem> itemList, // The list of items to check against.
  ) {
    // Set the values from the itemList to the service's items list.
    _setValues(itemList);

    // Find and return the index of the item in the items list.
    return items.indexWhere((element) => element.id == item.id);
  }

  // Creates an ActionLayerChange object to represent the change in layer index.
  ActionLayerChange _getChangeAction(
    PainterItem item, // The item whose layer index was changed.
    int oldIndex, // The old index of the item.
    int newIndex, // The new index of the item.
    PainterItem changedItem, // The updated item after the change.
    int changedItemOldIndex, // The old index of the changed item.
    int changedItemNewIndex, // The new index of the changed item.
  ) {
    // Create and return an ActionLayerChange to represent the change.
    return ActionLayerChange(
      item: item,
      oldIndex: oldIndex,
      newIndex: newIndex,
      changedItem: changedItem,
      changedItemOldIndex: changedItemOldIndex,
      changedItemNewIndex: changedItemNewIndex,
      timestamp: DateTime.now(), // Set the timestamp for the change.
      actionType:
          ActionType.changedLayerIndex, // Set the action type to indicate
      // a layer index change.
    );
  }

  // Sets the items list in the service to the provided itemList.
  void _setValues(
    List<PainterItem> itemList, // The list of items to set in the service.
  ) {
    items = itemList;
  }
}
