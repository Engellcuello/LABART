import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';
import 'package:labart/features/paint_drawing/lib/src/models/position_model.dart';

// Represents an action to change the position of an item.
class ActionPosition extends PaintAction {
  const ActionPosition({
    required this.oldPosition, // The previous position of the item.
    required this.newPosition, // The new position of the item.
    required this.item, // The item whose position changed.
    required super.timestamp, // Timestamp of when the action occurred.
    required super.actionType, // Type of action (positionItem).
  });

  final PainterItem item; // The item whose position is being updated.
  final PositionModel oldPosition; // The previous position of the item.
  final PositionModel newPosition; // The updated position of the item.
}
