import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/paint_action.dart';

class ActionLayerChange extends PaintAction {
  const ActionLayerChange({
    required this.item,
    required this.oldIndex,
    required this.newIndex,
    required this.changedItem,
    required this.changedItemOldIndex,
    required this.changedItemNewIndex,
    required super.timestamp,
    required super.actionType,
  });
  final PainterItem item;
  final int oldIndex;
  final int newIndex;
  final PainterItem changedItem;
  final int changedItemOldIndex;
  final int changedItemNewIndex;
}
