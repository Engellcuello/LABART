import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';

// Represents a specific action where the value of a shape item has changed.
class ActionShapeChangeValue extends PaintAction {
  const ActionShapeChangeValue({
    required this.currentItem, // The current state of the
    //shape item after the change.
    required this.lastItem, // The previous state of the
    //shape item before the change.
    required super.timestamp, // Timestamp of when the change occurred.
    required super.actionType, // Type of action (changeShapeValue).
  });

  final ShapeItem currentItem; // The updated version of the shape item.
  final ShapeItem
      lastItem; // The previous version of the shape item before the change.
}
