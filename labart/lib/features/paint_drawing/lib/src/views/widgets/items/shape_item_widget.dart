import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/position_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/rotate_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/size_action.dart';
import 'package:labart/features/paint_drawing/lib/src/views/shapes/arrow_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/views/shapes/circle_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/views/shapes/double_arrow_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/views/shapes/line_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/views/shapes/rectangle_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/views/shapes/star_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/views/shapes/triangle_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/views/widgets/measure_size.dart';
import 'package:labart/features/paint_drawing/lib/src/views/widgets/painter_container/painter_container.dart';

// This widget represents a shape item in the painter application.
class ShapeItemWidget extends StatefulWidget {
  const ShapeItemWidget({
    required this.item, // The shape item to be displayed.
    required this.height, // The height of the widget.
    required this.canvasSize, // The size of the canvas.
    required this.painterController, // The controller responsible
    // for managing the painter state.
    super.key,
    this.onPositionChange, // Callback when the position of the shape changes.
    this.onSizeChange, // Callback when the size of the shape changes.
    this.onRotationChange, // Callback when the rotation of the shape changes.
    this.onTapItem, // Callback when the shape item is tapped.
  });

  final ShapeItem item; // The shape item that is being rendered.
  final double height; // The height of the widget.
  final Size canvasSize;
  final void Function(PositionModel)?
      onPositionChange; // Callback for position change.
  final void Function(PositionModel, SizeModel)?
      onSizeChange; // Callback for size change.
  final void Function(double)?
      onRotationChange; // Callback for rotation change.
  final void Function()? onTapItem; // Callback when the shape is tapped.

  final PainterController
      painterController; // The controller for managing the painter.

  @override
  State<ShapeItemWidget> createState() => _ShapeItemWidgetState();
}

class _ShapeItemWidgetState extends State<ShapeItemWidget> {
  double? widgetHeight; // Stores the widget's height.
  ValueNotifier<PositionModel> position = ValueNotifier(
    const PositionModel(x: 50, y: 50),
  ); // Value notifier for shape position.

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: position, // Listens to the position changes.
      builder: (context, value, child) {
        return PainterContainer(
          selectedItem: widget.painterController.value.selectedItem != null &&
              widget.painterController.value.selectedItem?.id == widget.item.id,
          height: widget.height, // Passes the widget height to the container.
          canvasSize:
              widget.canvasSize, // Passes the canvas size to the container.
          minimumContainerHeight: 10, // Sets the minimum container height.
          minimumContainerWidth: 10, // Sets the minimum container width.
          position: widget.item.position, // The position of the shape.
          rotateAngle: widget.item.rotation, // The rotation angle of the shape.
          size: widget.item.size, // The size of the shape.

          // When the selected item changes, update the
          // painter controller's selected item.
          selectedItemChange: () {
            widget.painterController.value = widget.painterController.value
                .copyWith(selectedItem: widget.item);
          },

          // Handles the position change event.
          onPositionChange: (oldPosition, newPosition) {
            position.value = newPosition; // Update the position.
            widget.onPositionChange
                ?.call(newPosition); // Call the position change callback.
          },

          // Handles the rotation angle change event.
          onRotateAngleChange: (oldRotateAngle, newRotateAngle) {
            widget.onRotationChange
                ?.call(newRotateAngle); // Call the rotation change callback.
          },

          // Handles the size change event.
          onSizeChange: (newPosition, oldSize, newSize) {
            widget.onSizeChange
                ?.call(newPosition, newSize); // Call the size change callback.
          },

          // Actions triggered when the position change ends.
          onPositionChangeEnd: (
            oldPosition,
            newPosition,
          ) {
            widget.painterController.addAction(
              ActionPosition(
                item: widget.item,
                oldPosition: oldPosition,
                newPosition: newPosition,
                timestamp: DateTime.now(),
                actionType: ActionType.positionItem,
              ),
            );
          },

          // Actions triggered when the rotation change ends.
          onRotateAngleChangeEnd: (oldRotateAngle, newRotateAngle) {
            widget.painterController.addAction(
              ActionRotation(
                item: widget.item,
                oldRotateAngle: oldRotateAngle,
                newRotateAngle: newRotateAngle,
                timestamp: DateTime.now(),
                actionType: ActionType.rotationItem,
              ),
            );
          },

          // Actions triggered when the size change ends.
          onSizeChangeEnd: (oldPosition, oldSize, newPosition, newSize) {
            widget.painterController.addAction(
              ActionSize(
                item: widget.item,
                oldPosition: oldPosition,
                newPosition: newPosition,
                oldSize: oldSize,
                newSize: newSize,
                timestamp: DateTime.now(),
                actionType: ActionType.sizeItem,
              ),
            );
          },

          // Handles tap events on the item.
          onTapItem: ({bool? tapItem}) {
            if (tapItem != null && !tapItem && widget.onTapItem != null) {
              widget.onTapItem!
                  .call(); // Call the onTapItem callback if defined.
            }
          },

          // Enables the container only if the widgetHeight is not null.
          enabled: widgetHeight != null,

          // Sets the color of the drag handle based
          //on the painter controller's settings.
          dragHandleColor:
              widget.painterController.value.settings.itemDragHandleColor,

          // Centers the child widget inside the container.
          centerChild: true,

          // Checks if the item should be rendered
          renderItem: widget.painterController.itemRender.copyWith(
            containerItemId: widget.item.id,
          ),
          // Assigns the rendered image to the painterController
          onRenderImage: (item) {
            widget.painterController.itemRender = item;
          },
          child: MeasureSize(
            // Measures the size of the widget and
            //sets the height if it's not already set.
            onChange: (size) {
              if (widgetHeight != null) return;
              setState(() {
                widgetHeight = size.height; // Update the height.
              });
            },
            child: SizedBox(
              width: double
                  .infinity, // Ensure the width takes up all available space.
              child: shape, // Displays the shape widget.
            ),
          ),
        );
      },
    );
  }

  // Returns the appropriate shape widget based on the shape type.
  Widget get shape => SizedBox(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return CustomPaint(
              size: Size(
                constraints
                    .maxWidth, // Set the width based on the available space.
                constraints
                    .maxHeight, // Set the height based on the available space.
              ),
              painter: returnPainter(
                thickness:
                    widget.item.thickness, // Thickness of the shape's border.
                backgroundColor: widget
                    .item.backgroundColor, // Background color of the shape.
                width: constraints.maxWidth, // Width of the shape.
                height: constraints.maxHeight, // Height of the shape.
                lineColor: widget.item.lineColor, // Color of the shape's lines.
              ),
            );
          },
        ),
      );

  // Returns the appropriate painter based on the shape type.
  CustomPainter returnPainter({
    required double thickness,
    required Color backgroundColor,
    required double width,
    required double height,
    required Color lineColor,
  }) {
    // Return different painters based on the shape type.
    if (widget.item.shapeType == ShapeType.arrow) {
      return ArrowPainter(
        thickness: thickness,
        lineColor: lineColor,
      );
    } else if (widget.item.shapeType == ShapeType.doubleArrow) {
      return DoubleArrowPainter(
        thickness: thickness,
        lineColor: lineColor,
      );
    } else if (widget.item.shapeType == ShapeType.rectangle) {
      return RectanglePainter(
        thickness: thickness,
        lineColor: lineColor,
        backgroundColor: backgroundColor,
      );
    } else if (widget.item.shapeType == ShapeType.triangle) {
      return TrianglePainter(
        thickness: thickness,
        lineColor: lineColor,
        backgroundColor: backgroundColor,
      );
    } else if (widget.item.shapeType == ShapeType.star) {
      return StarPainter(
        thickness: thickness,
        lineColor: lineColor,
        backgroundColor: backgroundColor,
      );
    } else if (widget.item.shapeType == ShapeType.circle) {
      return CirclePainter(
        thickness: thickness,
        lineColor: lineColor,
        backgroundColor: backgroundColor,
      );
    } else {
      return LinePainter(
        thickness: thickness,
        lineColor: lineColor,
      );
    }
  }
}
