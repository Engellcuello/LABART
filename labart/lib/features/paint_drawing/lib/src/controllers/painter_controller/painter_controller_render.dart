part of 'painter_controller.dart';

extension PainterControllerRender on PainterController {
  /// Renders the current painting as an image and returns it as a Uint8List.
  /// This can be used to save or share the painted content.
  Future<Uint8List?> renderImage({double pixelRatio = 1.0}) async {
    try {
      clearSelectedItem(); // Deselect any selected item before rendering.
      await Future.delayed(const Duration(milliseconds: 100), () {});
      final boundary = repaintBoundaryKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null; // Return null if rendering fails.
    }
  }

  Future<Uint8List?> renderItem(
    PainterItem item, {
    bool enableRotation = false,
  }) async {
    itemRender = RenderItem(itemId: item.id, enableRotation: enableRotation);
    refreshValue();
    await Future.delayed(const Duration(milliseconds: 100), () {});
    final image = itemRender.image;
    itemRender.image = null;
    return image;
  }
}
