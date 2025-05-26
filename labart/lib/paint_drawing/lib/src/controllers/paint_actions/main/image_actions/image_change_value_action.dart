import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';

// Represents a specific action where the value of an image item has changed.
class ActionImageChangeValue extends PaintAction {
  const ActionImageChangeValue({
    required this.currentItem, // The current state of the
    //image item after the change.
    required this.lastItem, // The previous state of the image
    //item before the change.
    required super.timestamp, // Timestamp of when the change occurred.
    required super.actionType, // Type of action (changeImageValue).
  });

  final ImageItem currentItem; // The updated version of the image item.
  final ImageItem
      lastItem; // The previous version of the image item before the change.
}
