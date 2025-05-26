part of '../../painter_controller.dart';

extension PainterControllerPaintValues on PainterController {
  // updates brush size or color
  void changeBrushValues({
    double? size,
    Color? color,
  }) {
    value = value.copyWith(
      brushSize: size ?? value.brushSize,
      brushColor: color ?? value.brushColor,
    );
  }

  // updates eraser size
  void changeEraseValues({
    double? size,
    Color? color,
  }) {
    value = value.copyWith(
      eraseSize: size ?? value.eraseSize,
    );
  }
}
