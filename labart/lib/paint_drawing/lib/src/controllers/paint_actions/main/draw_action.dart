import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';
import 'package:labart/features/paint_drawing/lib/src/models/brush_model.dart';

// Represents an action to draw on the canvas.
class ActionDraw extends PaintAction {
  const ActionDraw({
    required this.paintPath, // The path that was drawn on the canvas.
    required this.listIndex, // The index in the list where
    //the drawing occurred.
    required super.timestamp, // Timestamp of when the action occurred.
    required super.actionType, // Type of action (draw).
  });

  final List<DrawModel?> paintPath; // The drawn path on the canvas.
  final int listIndex; // The index in the list for this drawing action.
}
