import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';

// Represents an action to remove an item from the list.
class ActionRemoveItem extends PaintAction {
  const ActionRemoveItem({
    required this.item, // The item being removed.
    required this.listIndex, // The index in the list where
    //the item was removed from.
    required super.timestamp, // Timestamp of when the action occurred.
    required super.actionType, // Type of action (removedItem).
  });

  final PainterItem item; // The item being removed from the list.
  final int listIndex; // The index in the list from where the item was removed.
}
