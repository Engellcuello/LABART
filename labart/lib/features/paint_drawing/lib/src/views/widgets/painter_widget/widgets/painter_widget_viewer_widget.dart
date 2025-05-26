part of '../painter_widget.dart';

// A StatelessWidget that serves as the viewer for
//the painting or drawing, allowing interactive viewing, zooming, and panning.
class _ViewerWidget extends StatelessWidget {
  // Constructor for the _ViewerWidget, which
  //requires a PainterController instance.
  const _ViewerWidget({required this.controller, this.boundaryMargin});

  // The PainterController that controls the
  //background, drawing, and erasing logic.
  final PainterController controller;

  final double? boundaryMargin;
  // Builds the widget tree for displaying the
  //viewer with interactive capabilities.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final widgetBoundaryMargin = boundaryMargin ?? 20.0;
        final totalHorizontalMargin =
            widgetBoundaryMargin * 2; // Sağ ve sol margin
        final totalVerticalMargin =
            widgetBoundaryMargin * 2; // Üst ve alt margin

        final screenWidth = constraints.maxWidth - totalHorizontalMargin;
        final screenHeight = constraints.maxHeight - totalVerticalMargin;

        return InteractiveViewer(
          boundaryMargin: EdgeInsets.all(widgetBoundaryMargin),
          minScale: 0.1,
          maxScale: 10,
          child: Center(
            child: (controller.background.width == 0 ||
                    controller.background.height == 0)
                ? null
                : SizedBox(
                    width: screenWidth,
                    height: screenHeight,
                    child: FittedBox(
                      child: SizedBox(
                        width: controller.background.width,
                        height: controller.background.height,
                        child: (!(controller.isDrawing || controller.isErasing))
                            ? _MainWidget(controller: controller)
                            : _DrawingWidget(
                                controller: controller,
                                child: _MainWidget(
                                  controller: controller,
                                ),
                              ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
