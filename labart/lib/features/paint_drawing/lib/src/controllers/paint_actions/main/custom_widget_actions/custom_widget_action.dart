import 'package:labart/features/paint_drawing/lib/src/controllers/items/custom_widget_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';

// Represents a specific action where the value of an image item has changed.
class ActionCustomWidgetChangeValue extends PaintAction {
  const ActionCustomWidgetChangeValue({
    required this.currentItem, // The current state of the
    //custom widget item after the change.
    required this.lastItem, // The previous state of the custom widget
    //item before the change.
    required super.timestamp, // Timestamp of when the change occurred.
    required super.actionType, // Type of action (changeCustomWidgetValue).
  });

  final CustomWidgetItem
      currentItem; // The updated version of the custom widget item.
  final CustomWidgetItem lastItem; // The previous version of the custom widget
  //item before the change.
}
