part of '../painter_controller.dart';

extension PainterControllerItemShape on PainterController {
  // adds a new shape to the canvas
  void addShape(ShapeType shapeType, {String? layerTitle}) {
    final shapeItem = ShapeItem(
      shapeType: shapeType,
      position: const PositionModel(),
      layer: LayerSettings(
        title: layerTitle ??
            'Shape (${value.items.whereType<ShapeItem>().length})',
        index: value.items.length,
      ),
      size: ShapeItem.defaultSize(shapeType),
    );
    value = value.copyWith(
      items: value.items.toList()..insert(0, shapeItem),
    );
    addAction(
      ActionAddItem(
        item: shapeItem,
        listIndex: value.items.length - 1,
        timestamp: DateTime.now(),
        actionType: ActionType.addedShapeItem,
      ),
    );
    value.selectedItem = shapeItem;
  }
}
