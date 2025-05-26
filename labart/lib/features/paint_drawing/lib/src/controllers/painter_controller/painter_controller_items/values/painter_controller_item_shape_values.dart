part of '../../painter_controller.dart';

extension PainterControllerItemShapeValues on PainterController {
  // updates properties for a ShapeItem
  void changeShapeValues(
    ShapeItem item, {
    ShapeType? shapeType,
    Color? backgroundColor,
    Color? lineColor,
    double? thickness,
  }) {
    final newItem = item.copyWith(
      shapeType: shapeType ?? item.shapeType,
      backgroundColor: backgroundColor ?? item.backgroundColor,
      lineColor: lineColor ?? item.lineColor,
      thickness: thickness ?? item.thickness,
    );
    _changeItemValues(newItem);
  }
}
