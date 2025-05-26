import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/custom_widget_actions/custom_widget_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/image_actions/image_change_value_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/position_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/rotate_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/shape_actions/shape_change_value_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/size_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/text_actions/text_change_value_action.dart';

class ChangeItemValuesService {
  // A list to store PainterItem objects.
  List<PainterItem> items = [];

  // Changes the values of a specific PainterItem in the items list.
  void changeItemValues(
    PainterItem item, // The item to update.
    List<PainterItem> itemsList, // The list of items to update from.
    void Function(
      PaintAction action, // The action taken (for undo/redo purposes).
      List<PainterItem> items, // The updated list of items.
      dynamic selectedItem, // The selected item to be updated.
    ) updatedValues, // Callback function to update values.
  ) {
    // Assign the provided list of items to the service's items list.
    items = itemsList;
    // Initialize the index variable to 0.
    var index = 0;
    // Find the last item in the list that matches the provided item.
    // The index of the found item is assigned to the index variable.
    final lastItem = _findLastItem(item, (itemIndex) => index = itemIndex);

    // Create a new item with updated values based on the last item.
    final newItem = item.copyWith(
      size: lastItem.size, // Keep the size unchanged.
      position: lastItem.position, // Keep the position unchanged.
      rotation: lastItem.rotation, // Keep the rotation unchanged.
    );

    // Remove the old item and insert the new item at the same index.
    items
      ..removeAt(index)
      ..insert(index, newItem);

    // Call the updatedValues function to apply the changes.
    updatedValues(_getValuesAction(newItem, lastItem), items, item);
  }

  // Changes the properties of a specific PainterItem.
  void changeItemProperties(
    PainterItem item, // The item to update.
    List<PainterItem> itemsList, // The list of items to update from.
    void Function(
      PaintAction action, // The action taken (for undo/redo purposes).
      List<PainterItem> items, // The updated list of items.
      dynamic selectedItem, // The selected item to be updated.
    ) updatedValues, // Callback function to update values.
  ) {
    // Assign the provided list of items to the service's items list.
    items = itemsList;
    // Initialize the index variable to 0.
    var index = 0;
    // Find the last item in the list that matches the provided item.
    // The index of the found item is assigned to the index variable.
    final lastItem = _findLastItem(item, (itemIndex) => index = itemIndex);
    // Check if the size has changed.
    if (lastItem.size != item.size) {
      final actionItem = lastItem.copyWith(size: item.size);
      // Update the items list with the new item.
      items
        ..removeAt(index)
        ..insert(
          index,
          item.copyWith(
            size: lastItem.size,
          ),
        ); // Keep the size. Because the item size is null.
      // Call the updatedValues function to apply the changes.
      updatedValues(_getPropertiesAction(actionItem, lastItem), items, item);
    }

    // Check if the position has changed.
    if (lastItem.position != item.position) {
      final actionItem = lastItem.copyWith(position: item.position);
      // Update the items list with the new item.
      items
        ..removeAt(index)
        ..insert(index, item);
      // Call the updatedValues function to apply the changes.
      updatedValues(_getPropertiesAction(actionItem, lastItem), items, item);
    }

    // Check if the rotation has changed.
    if (lastItem.rotation != item.rotation) {
      final actionItem = lastItem.copyWith(rotation: item.rotation);
      // Update the items list with the new item.
      items
        ..removeAt(index)
        ..insert(index, item);
      // Call the updatedValues function to apply the changes.
      updatedValues(_getPropertiesAction(actionItem, lastItem), items, item);
    }
  }

  // Determines the appropriate action type for the change based on item types.
  PaintAction _getValuesAction(PainterItem item, PainterItem lastItem) {
    // If the item is a TextItem, create a change action for text.
    if (item is TextItem && lastItem is TextItem) {
      return ActionTextChangeValue(
        currentItem: item,
        lastItem: lastItem,
        timestamp: DateTime.now(), // Timestamp for the action.
        actionType:
            ActionType.changeTextValue, // Action type: change text value.
      );
    }
    // If the item is an ImageItem, create a change action for image.
    else if (item is ImageItem && lastItem is ImageItem) {
      return ActionImageChangeValue(
        currentItem: item,
        lastItem: lastItem,
        timestamp: DateTime.now(), // Timestamp for the action.
        actionType:
            ActionType.changeImageValue, // Action type: change image value.
      );
    }
    // Otherwise, create a change action for a shape item.
    else if (item is ShapeItem && lastItem is ShapeItem) {
      return ActionShapeChangeValue(
        currentItem: item, // Cast the item to ShapeItem.
        lastItem: lastItem, // Cast the last item to ShapeItem.
        timestamp: DateTime.now(), // Timestamp for the action.
        actionType:
            ActionType.changeShapeValue, // Action type: change shape value.
      );
    }
    // If the item is a CustomWidgetItem, create a change action
    //for custom widget.
    else {
      return ActionCustomWidgetChangeValue(
        currentItem: item as CustomWidgetItem,
        lastItem: lastItem as CustomWidgetItem,
        timestamp: DateTime.now(), // Timestamp for the action.
        actionType:
            ActionType.changeCustomWidgetValue, // Action type: change custom
        //widget value.
      );
    }
  }

  PaintAction _getPropertiesAction(PainterItem item, PainterItem lastItem) {
    // If the item position is different from the last item position, create a
    // position action.
    if (item.position != lastItem.position) {
      return ActionPosition(
        item: item,
        oldPosition: lastItem.position,
        newPosition: item.position,
        timestamp: DateTime.now(),
        actionType: ActionType.positionItem,
      );
    }

    //if the item rotation is different from the last item rotation, create
    //a rotation action.
    if (item.rotation != lastItem.rotation) {
      return ActionRotation(
        item: item,
        oldRotateAngle: lastItem.rotation,
        newRotateAngle: item.rotation,
        timestamp: DateTime.now(),
        actionType: ActionType.rotationItem,
      );
    }
    //if the item size is different from the last item size,
    //create a size action.
    return ActionSize(
      item: item,
      oldPosition: lastItem.position,
      newPosition: item.position,
      oldSize: lastItem.size ?? SizeModel.empty(),
      newSize: item.size ?? SizeModel.empty(),
      timestamp: DateTime.now(),
      actionType: ActionType.sizeItem,
    );
  }

  PainterItem _findLastItem(
    PainterItem item,
    void Function(int itemIndex) itemIndexCallback,
  ) {
    // Find the index of the item to be updated by matching IDs.
    final index = items.indexWhere((element) => element.id == item.id);
    itemIndexCallback(index);
    return items[index];
  }
}
