import 'package:flutter/material.dart';
import 'package:labart/features/paint_drawing/lib/simple_painter.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/position_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/rotate_action.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/paint_actions/main/size_action.dart';
import 'package:labart/features/paint_drawing/lib/src/views/widgets/measure_size.dart';
import 'package:labart/features/paint_drawing/lib/src/views/widgets/painter_container/painter_container.dart';

/// The TextItemWidget is a StatefulWidget that displays a
/// text item with various customizable properties.
class TextItemWidget extends StatefulWidget {
  const TextItemWidget({
    required this.item, // The text item to display
    required this.height, // The height of the widget
    required this.canvasSize, // The size of the canvas
    required this.painterController, // The painter controller
    //or managing the painter's state
    super.key, // Key for the widget, used for managing widget state
    this.onPositionChange, // Callback when the position of the item changes
    this.onSizeChange, // Callback when the size of the item changes
    this.onRotationChange, // Callback when the
    //rotation angle of the item changes
    this.onTapItem, // Callback when the item is tapped
  });

  final TextItem item; // The text item that will be rendered
  final double height; // Height of the widget
  final Size canvasSize;
  final void Function(PositionModel)?
      onPositionChange; // Callback for position change
  final void Function(PositionModel, SizeModel)?
      onSizeChange; // Callback for size change
  final void Function(double)? onRotationChange; // Callback for rotation change
  final void Function()? onTapItem; // Callback when the item is tapped
  final PainterController
      painterController; // The controller for painter actions

  @override
  State<TextItemWidget> createState() =>
      _TextItemWidgetState(); // Creates the state for this widget
}

// The state class of TextItemWidget, responsible for managing stateful behavior
class _TextItemWidgetState extends State<TextItemWidget> {
  double? widgetHeight; // The height of the widget that will be calculated
  ValueNotifier<PositionModel> position = ValueNotifier(
    const PositionModel(x: 50, y: 50),
  ); // The position of the text item

  @override
  Widget build(BuildContext context) {
    // Builds the widget tree using the current state
    return ValueListenableBuilder(
      valueListenable: position, // Listens to changes in position
      builder: (context, value, child) {
        return PainterContainer(
          selectedItem: widget.painterController.value.selectedItem != null &&
              widget.painterController.value.selectedItem?.id ==
                  widget.item.id, // Checks if the item is selected
          height: widget.height, // Passes the height of the widget
          canvasSize:
              widget.canvasSize, // Passes the canvas size to the container.
          minimumContainerHeight:
              widgetHeight, // Minimum height of the container
          position: widget.item.position, // The position of the item
          rotateAngle: widget.item.rotation, // The rotation angle of the item
          size: widget.item.size, // The size of the item
          selectedItemChange: () {
            widget.painterController.value =
                widget.painterController.value.copyWith(
              selectedItem: widget.item,
            ); // Updates the selected item in the painter controller
          },
          onPositionChange: (oldPosition, newPosition) {
            position.value = newPosition; // Updates the position
            widget.onPositionChange
                ?.call(newPosition); // Calls the position change callback
          },
          onRotateAngleChange: (oldRotateAngle, newRotateAngle) {
            widget.onRotationChange
                ?.call(newRotateAngle); // Calls the rotation change callback
          },
          onSizeChange: (newPosition, oldSize, newSize) {
            widget.onSizeChange
                ?.call(newPosition, newSize); // Calls the size change callback
          },
          onPositionChangeEnd: (oldPosition, newPosition) {
            widget.painterController.addAction(
              ActionPosition(
                item: widget.item,
                oldPosition: oldPosition,
                newPosition: newPosition,
                timestamp: DateTime.now(),
                actionType: ActionType.positionItem,
              ),
            ); // Records the position change action
          },
          onRotateAngleChangeEnd: (oldRotateAngle, newRotateAngle) {
            widget.painterController.addAction(
              ActionRotation(
                item: widget.item,
                oldRotateAngle: oldRotateAngle,
                newRotateAngle: newRotateAngle,
                timestamp: DateTime.now(),
                actionType: ActionType.rotationItem,
              ),
            ); // Records the rotation change action
          },
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
            ); // Records the size change action
          },
          onTapItem: ({bool? tapItem}) {
            if (tapItem != null && !tapItem && widget.onTapItem != null) {
              widget.onTapItem!
                  .call(); // Calls the onTapItem callback if the item is tapped
            }
          },
          enabled:
              widgetHeight != null, // Enables the widget if height is not null
          dragHandleColor: widget.painterController.value.settings
              .itemDragHandleColor, // The color of the drag handle
          centerChild: true, // Centers the child widget

          // Checks if the item should be rendered
          renderItem: widget.painterController.itemRender.copyWith(
            containerItemId: widget.item.id,
          ),
          // Assigns the rendered image to the painterController
          onRenderImage: (item) {
            widget.painterController.itemRender = item;
          },
          child: MeasureSize(
            onChange: (size) {
              if (widgetHeight != null) {
                return; // Prevents recalculating height if it's already set
              }
              setState(() {
                widgetHeight = size.height; // Sets the height of the widget
              });
            },
            child: SizedBox(
              width: double.infinity, // Makes the child widget
              //take up all available width
              child: widget.item.enableGradientColor
                  ? ShaderMask(
                      blendMode: BlendMode.srcIn, // Uses a shader to
                      //apply a gradient to the text
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: widget.item.gradientBegin,
                          end: widget.item.gradientEnd,
                          colors: [
                            widget.item.gradientStartColor,
                            widget.item.gradientEndColor,
                          ],
                          stops: const [0.0, 1.0],
                        ).createShader(
                          bounds,
                        ); // Creates the shader with the gradient colors
                      },
                      child: text, // Applies the gradient shader to the text
                    )
                  : text, // If no gradient is enabled, simply display the text
            ),
          ),
        );
      },
    );
  }

  // A getter for the text widget that displays the text item
  Widget get text => Text(
        widget.item.text, // The text content of the item
        textAlign:
            widget.item.textAlign, // Text alignment (e.g., left, center, right)
        style: widget.item.textStyle.copyWith(
          backgroundColor: widget.item.enableGradientColor
              ? Colors.transparent
              : widget
                  .item.textStyle.backgroundColor, // If gradient is enabled,
          //set background to transparent
        ),
      );
}
