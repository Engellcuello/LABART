part of '../painter_widget.dart';

// A StatelessWidget that builds the main content
//of the painting or drawing canvas, handling
//background images and drawing elements.
class _MainWidget extends StatelessWidget {
  // Constructor that requires a PainterController
  //to control the painting logic.
  const _MainWidget({required this.controller});

  // The PainterController instance that manages
  //the painting state and the background.
  final PainterController controller;

  // Builds the widget tree for displaying the main canvas content.
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: controller.repaintBoundaryKey,
      child: GestureDetector(
        onTap: controller.clearSelectedItem,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: _buildMainWidget(),
          ),
        ),
      ),
    );
  }

  // A helper method to decide how to build the
  //main widget content based on the background and drawing data.
  Widget _buildMainWidget() {
    // If a background image exists, handle displaying it.
    if (controller.background.image != null) {
      // If there is a cached version of the background image, use it.
      if (controller.cacheBackgroundImage != null) {
        return customPaint(backgroundImage: controller.cacheBackgroundImage);
      }
      // If the image is not cached, load it asynchronously.
      return FutureBuilder<ui.Image?>(
        future: uint8ListToUiImage(
          controller.background.image!,
        ), // Asynchronously convert the background
        //image from a byte array to ui.Image.
        builder: (context, snapshot) {
          // When the image is successfully loaded, cache it
          //and display the canvas with the background image.
          if (snapshot.connectionState == ConnectionState.done) {
            controller.cacheBackgroundImage =
                snapshot.data; // Cache the loaded background image.
            return customPaint(
              backgroundImage: snapshot.data,
            ); // Render the canvas with the background image.
          }
          // If the image is still loading, just render the
          //canvas without the background image.
          return customPaint();
        },
      );
    }
    // If there is no background image, render the canvas without a background.
    return customPaint();
  }

  // A helper method to create a CustomPaint widget,
  //which draws the paths and items.
  Widget customPaint({ui.Image? backgroundImage}) {
    return SizedBox(
      width: controller.value.settings.size.width,
      height: controller.value.settings.size.height,
      child: CustomPaint(
        size: controller.value.settings.size, // The size of the canvas.
        willChange: true,
        painter: PainterCustomPaint(
          isErasing: false, // Set the state to not erasing for now.
          paths: controller.value.paintPaths
              .toList(), // The list of paths to be drawn.
          points: controller.value.currentPaintPath
              .toList(), // The current path being drawn.
          backgroundImage:
              backgroundImage, // The background image (if any) to be drawn.
        ),
        child: Stack(
          children: controller.value.items
              // For each item in the controller's value, create
              //an ItemWidget to display it.
              .map(
                (item) =>
                    PainterWidgetItemWidget(item: item, controller: controller),
              )
              .toList()
              .reversed
              .toList(), // Reverse the list of items to layer
          //them properly (back to front).
        ),
      ),
    );
  }

  // A utility function to convert a Uint8List (byte array)
  //to a ui.Image asynchronously.
  Future<ui.Image?> uint8ListToUiImage(Uint8List uint8List) async {
    try {
      final completer = Completer<
          ui.Image>(); // A Completer to handle asynchronous image decoding.
      ui.decodeImageFromList(
        uint8List,
        completer.complete,
      ); // Decode the byte array to an image.
      return completer
          .future; // Return the future that completes with the decoded image.
    } catch (e) {
      return null; // If there is an error in decoding, return null.
    }
  }
}
