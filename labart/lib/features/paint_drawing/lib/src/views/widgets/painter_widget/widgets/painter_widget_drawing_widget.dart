part of '../painter_widget.dart';

// This class defines a widget for handling drawing interactions with the user.
class _DrawingWidget extends StatelessWidget {
  const _DrawingWidget({required this.controller, required this.child});

  // The controller that manages drawing states and properties.
  final PainterController controller;

  // The child widget that will be wrapped by the drawing functionality.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // GestureDetector is used to handle touch
    //interactions for drawing and erasing.
    return _PanGestureDetector(
      // The touchSlop property is set to 0 to
      //allow for more precise touch interactions.
      touchSlop: 0,
      // The onPanUpdate method is triggered
      //when the user moves their finger or stylus.
      onPanUpdate: (details) {
        // Checks if the user is either drawing or erasing.
        if (controller.isDrawing || controller.isErasing) {
          // Adds a new drawing point to the controller
          //based on the user's touch position.
          // If erasing, the color is set to transparent;
          //otherwise, it uses the brush color.
          controller.addPaintPoint(
            DrawModel(
              offset: details.localPosition, // The current touch position.
              color: controller.isErasing
                  ? Colors.transparent // If erasing, set color to transparent.
                  : controller
                      .value.brushColor, // Otherwise, use the brush color.
              strokeWidth: controller.value.brushSize, // The size of the brush.
            ),
          );
        }
      },

      // The onPanEnd method is triggered when the user
      //stops interacting (finger or stylus lifts).
      onPanEnd: (details) {
        // Ensures that the drawing or erasing action is
        //finalized once the user stops.
        if (controller.isDrawing || controller.isErasing) {
          // Ends the current drawing path when the user
          //lifts their finger or stylus.
          controller.endPath();
        }
      },

      // Returns the child widget wrapped with-
      //the gesture detection functionality.
      child: child,
    );
  }
}
