import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';

// Represents an action to rotate an item.
class ActionRotation extends PaintAction {
  const ActionRotation({
    required this.oldRotateAngle, // The previous rotation angle of the item.
    required this.newRotateAngle, // The updated rotation angle of the item.
    required this.item, // The item being rotated.
    required super.timestamp, // Timestamp of when the action occurred.
    required super.actionType, // Type of action (rotationItem).
  });

  final PainterItem item; // The item being rotated.
  final double oldRotateAngle; // The previous rotation angle of the item.
  final double newRotateAngle; // The updated rotation angle of the item.
}
