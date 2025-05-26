import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';
import 'package:labart/features/paint_drawing/lib/src/models/brush_model.dart';

// Represents an action to erase something from the canvas.
class ActionErase extends PaintAction {
  const ActionErase({
    required this.lastPaintPath, // The paint path before the erase.
    required this.currentPaintPath, // The paint path after the erase.
    required super.timestamp, // Timestamp of when the action occurred.
    required super.actionType, // Type of action (erase).
  });

  final List<List<DrawModel?>> lastPaintPath; // The path before erasing.
  final List<List<DrawModel?>> currentPaintPath; // The path after erasing.
}
