import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';

// Represents a specific action where the value of a text item has changed.
class ActionTextChangeValue extends PaintAction {
  const ActionTextChangeValue({
    required this.currentItem, // The current state of the
    // text item after the change.
    required this.lastItem, // The previous state of the
    //text item before the change.
    required super.timestamp, // Timestamp of when the change occurred.
    required super.actionType, // Type of action (changeTextValue).
  });

  final TextItem currentItem; // The updated version of the text item.
  final TextItem
      lastItem; // The previous version of the text item before the change.
}
