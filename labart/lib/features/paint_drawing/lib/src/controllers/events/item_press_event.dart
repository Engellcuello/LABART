import 'package:labart/features/paint_drawing/lib/src/controllers/events/controller_event.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/items/painter_item.dart';
/// An event triggered when an item is pressed in the painter controller.
class ItemPressEvent extends ControllerEvent {
  const ItemPressEvent({
    required this.item,
    required this.layerIndex,
  });

  /// The item that was pressed.
  final PainterItem item;

  /// The index of the layer where the item is located.
  final int layerIndex;
}
