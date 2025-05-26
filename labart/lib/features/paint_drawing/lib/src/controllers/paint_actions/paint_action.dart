import 'package:equatable/equatable.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/action_type_enum.dart';

// Represents a single paint action, with a specific action type and timestamp.
class PaintAction extends Equatable {
  const PaintAction({
    required this.actionType, // Type of the action (e.g., add, remove, move).
    required this.timestamp, // Timestamp when the action occurred.
  });

  final ActionType actionType; // The type of action (add, remove, etc.).
  final DateTime timestamp; // The exact time the action was performed.

  @override
  // Overrides the equality method to compare PaintActions
  //// based on actionType and timestamp.
  List<Object> get props => [actionType, timestamp];
}
