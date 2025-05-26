// part of the painter_container.dart file
part of '../painter_container.dart';

// This class represents a widget for the handle that allows users to resize
// a container. It is used within the `_StackHandle` class to visually represent
// the resizing handles at various positions (top, bottom, left, right, center).
class _HandleWidget extends StatelessWidget {
  const _HandleWidget({
    required this.height,
    required this.width,
    required this.handlePosition,
    required this.backgroundColor,
  });
  final double height; // The height of the handle widget.
  final double width; // The width of the handle widget.
  final _HandlePosition handlePosition; // The position of the
  //handle (top, bottom, left, right, or center).
  final Color backgroundColor; // The background color of the handle.

  // Builds the handle widget based on the position and provided size.
  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          width, // Sets the width of the container based on the passed width.
      height: height, // Sets the height of the
      //container based on the passed height.
      color: Colors.transparent, // Makes the outer container transparent.
      child: Center(
        child: Container(
          width: getWidthFromPosition(), // Determines the
          //width based on the position.
          height: getHeightFromPosition(), // Determines the
          //height based on the position.
          decoration: BoxDecoration(
            color: backgroundColor, // Sets the background
            //color of the inner container.
            borderRadius: BorderRadius.circular(5), // Gives the inner container
            //rounded corners.
          ),
        ),
      ),
    );
  }

  // This method determines the height of the handle based on its position.
  // If the position is top or bottom, it will have a fixed height of 3.
  // Otherwise, it uses the provided height.
  double getHeightFromPosition() {
    if (handlePosition == _HandlePosition.top ||
        handlePosition == _HandlePosition.bottom) {
      return 3; // Fixed height for top and bottom handles.
    } else {
      return height; // Uses the passed height for other positions.
    }
  }

  // This method determines the width of the handle based on its position.
  // If the position is left or right, it will have a fixed width of 3.
  // Otherwise, it uses the provided width.
  double getWidthFromPosition() {
    if (handlePosition == _HandlePosition.left ||
        handlePosition == _HandlePosition.right) {
      return 3; // Fixed width for left and right handles.
    } else {
      return width; // Uses the passed width for other positions.
    }
  }
}
