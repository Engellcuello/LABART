import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';

// Represents a collection of paint actions with
//an index for tracking the current state.
class PaintActions {
  // List of all paint actions, representing a history of changes.
  List<PaintAction> changeList = <PaintAction>[];

  // Index to keep track of the current position in the change list.
  int index = -1;

  // Method to create a copy of PaintActions with
  ////optional updates for changeList and index.
  PaintActions copyWith({
    List<PaintAction>? changeList,
    int? index,
  }) {
    return PaintActions()
      ..changeList = changeList ??
          this.changeList // Use provided changeList or keep the current one.
      ..index =
          index ?? this.index; // Use provided index or keep the current one.
  }
}
