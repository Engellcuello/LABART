import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';

// Represents an action to add a new item to the list.
class ActionAddItem extends PaintAction {
  const ActionAddItem({
    required this.item, // The item being added.
    required this.listIndex, // The index in the list
    //where the item is being added.
    required super.timestamp, // Timestamp of when the action occurred.
    required super.actionType, // Type of action (addedTextItem,
    // addedImageItem, addedShapeItem).
  });

  final PainterItem item; // The item being added to the list.
  final int listIndex; // The index in the list where the item is added.
}
