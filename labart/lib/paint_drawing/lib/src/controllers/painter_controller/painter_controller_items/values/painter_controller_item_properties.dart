part of '../../painter_controller.dart';

extension PainterControllerItemProperties on PainterController {
  // updates properties for a item
  void changeItemProperties(
    PainterItem item, {
    PositionModel? position,
    double? rotation,
    SizeModel? size,
  }) {
    final newItem = item.copyWith(
      position: position ?? item.position,
      rotation: rotation ?? item.rotation,
      size: size ?? item.size,
    );
    _changeItemProperties(newItem);
  }
}
