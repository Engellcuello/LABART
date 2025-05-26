// ignore_for_file: library_private_types_in_public_api

part of '../painter_container.dart';
// part of the painter_container.dart file

// This function determines the width of the handle widget based on its position
// (top, bottom, left, or right). The width is dynamically calculated for the
// top and bottom handles based on the container's width, ensuring that it
// is always at least 15. The left and right handles use a fixed width
// provided as an argument.
double _getHandleWidgetWidth(
  _HandlePosition
      handlePosition, // The position of the handle (top, bottom, left, right).
  double
      handleWidgetWidth, // The fixed width of the handle widget for left/right positions.
  SizeModel containerSize, // The size of the container being resized.
) {
  switch (handlePosition) {
    case _HandlePosition.top:
    case _HandlePosition.bottom:
      // For top and bottom handles, the width is
      //calculated as a fraction of the container's width.
      // The width is set to at least 15, ensuring
      //that it never becomes too small.
      final size = containerSize.width / 7;
      return size < 15
          ? 15
          : size; // Return the calculated width or a minimum width of 15.
    case _HandlePosition.left:
    case _HandlePosition.right:
      // For left and right handles, return the fixed handle widget width.
      return handleWidgetWidth; // Fixed width for left and right handles.
  }
}

// This function determines the height of the
//handle widget based on its position
// (top, bottom, left, or right). The height is dynamically calculated for the
// left and right handles based on the container's height, ensuring that it
// is always at least 15. The top and bottom
//handles use the provided height value.
double _getHandleWidgetHeight(
  _HandlePosition
      handlePosition, // The position of the handle (top, bottom, left, right).
  double
      handleWidgetHeight, // The fixed height of the handle widget for top/bottom positions.
  SizeModel containerSize, // The size of the container being resized.
) {
  switch (handlePosition) {
    case _HandlePosition.top:
    case _HandlePosition.bottom:
      // For top and bottom handles, return the
      //fixed height for the handle widget.
      return handleWidgetHeight; // Fixed height for top and bottom handles.
    case _HandlePosition.left:
    case _HandlePosition.right:
      // For left and right handles, the height
      //is calculated as a fraction of the container's height.
      // The height is set to at least 15,
      //ensuring that it never becomes too small.
      final size = containerSize.height / 7;
      return size < 15
          ? 15
          : size; // Return the calculated height or a minimum height of 15.
  }
}

Future<Uint8List?> renderWidget(
  GlobalKey repaintBoundaryKey,
) async {
  try {
    final boundary = repaintBoundaryKey.currentContext!.findRenderObject()!
        as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  } catch (e) {
    return null; // Return null if rendering fails.
  }
}
