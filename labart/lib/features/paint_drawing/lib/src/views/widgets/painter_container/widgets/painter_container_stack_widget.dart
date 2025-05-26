// ignore_for_file: unused_element

part of '../painter_container.dart';

// This class defines a widget that can be positioned
//and scaled interactively within a stack.
// It also handles user interactions like tapping, scaling,
//and dragging, and adjusts the size and position of the widget accordingly.
class _StackWidget extends StatelessWidget {
  const _StackWidget({
    required this.oldPosition,
    required this.position,
    required this.stackHeight,
    required this.stackWidth,
    required this.rotateAngle,
    required this.oldRotateAngle,
    required this.handleWidgetHeight,
    required this.handleWidgetWidth,
    required this.minimumContainerWidth,
    required this.minimumContainerHeight,
    required this.stackPosition,
    required this.onTap,
    required this.onScaleStart,
    required this.onScaleEnd,
    required this.containerSize,
    required this.oldContainerSize,
    required this.scaleCurrentHeight,
    required this.currentRotateAngle,
    required this.onScaleUpdate,
    required this.initializeSize,
    required this.height,
    required this.handlePanEnd,
    required this.handlePanUpdate,
    required this.handleSizeChange,
    required this.selectedItem,
    this.child,
    this.enabled,
    this.centerChild,
    this.dragHandleColor,
    this.renderItem,
    this.onRenderImage,
  });

  // These variables hold the current and
  //previous positions and sizes of the widget.
  final PositionModel stackPosition;
  final PositionModel oldPosition;
  final PositionModel position;
  final double stackHeight;
  final double stackWidth;
  final double rotateAngle;
  final double oldRotateAngle;
  final double handleWidgetHeight;
  final double handleWidgetWidth;
  final double minimumContainerWidth;
  final double minimumContainerHeight;
  final double height;
  final bool? enabled;
  final bool selectedItem;
  final SizeModel containerSize;
  final SizeModel oldContainerSize;
  final double scaleCurrentHeight;
  final double currentRotateAngle;
  final bool initializeSize;
  final bool? centerChild;
  final Widget? child;
  // RenderItem object used to render the widget's content
  final RenderItem? renderItem;
  // Callback function triggered when the widget needs to render an image
  final void Function(
    RenderItem item,
  )? onRenderImage;

  final void Function() onTap;
  final void Function() onScaleStart;
  final void Function(ScaleEndDetails) onScaleEnd;
  final void Function(ScaleUpdateDetails details) onScaleUpdate;
  final Color? dragHandleColor;
  final void Function() handlePanEnd;
  final void Function(SizeModel containerSize, PositionModel? stackPosition)
      handlePanUpdate;
  final void Function(PositionModel, SizeModel, SizeModel) handleSizeChange;

  // The build method positions the widget
  //within a stack, handling interactions like tapping and scaling.
  @override
  Widget build(BuildContext context) {
    final repaintBoundaryKey =
        renderItem != null && renderItem!.itemId != null ? GlobalKey() : null;
    if (renderItem != null &&
        renderItem!.itemId != null &&
        renderItem!.isEqualToContainerItemId) {
      unawaited(
        Future(() async {
          var image = await renderWidget(repaintBoundaryKey!);
          if (renderItem!.enableRotation && image != null) {
            //rotate image
            image = await ImageService.rotateImage(image, rotateAngle);
          }
          onRenderImage?.call(
            renderItem!.copyWith(image: image),
          );
        }),
      );
    }
    return Positioned(
      left: stackPosition.x, // Position the widget on the X axis
      top: stackPosition.y, // Position the widget on the Y axis
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: handleWidgetHeight, // Padding for horizontal resizing
          vertical: handleWidgetWidth, // Padding for vertical resizing
        ),
        child: GestureDetector(
          onTap: onTap, // Handle tap events
          onScaleStart: (details) => onScaleStart.call(), // Handle scale start
          onScaleEnd: onScaleEnd.call, // Handle scale end
          onScaleUpdate: onScaleUpdate.call,
          child: Container(
            width: containerSize.width, // Set the container width
            height: containerSize.height, // Set the container height
            decoration: BoxDecoration(
              color: Colors.transparent, // Transparent background
              border: Border.all(
                color: selectedItem
                    ? dragHandleColor ??
                        Colors.blue // Border color when selected
                    : Colors.transparent, // No border when not selected
              ),
            ),
            child: RepaintBoundary(
              key: repaintBoundaryKey,
              child: mainChild,
            ),
          ),
        ),
      ),
    );
  }

  Widget? get mainChild => initializeSize // If size initialization is needed
      ? (centerChild != null &&
              centerChild!) // If the widget should be centered
          ? Center(child: child) // Center the child widget
          : child
      : Align(child: child); // Align the child widget otherwise
}
