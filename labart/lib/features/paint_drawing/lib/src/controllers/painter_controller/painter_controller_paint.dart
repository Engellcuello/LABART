part of 'painter_controller.dart';

extension PainterControllerPaint on PainterController {
  /// Adds a paint point to the current drawing path or performs erasing
  /// if the eraser mode is enabled.
  void addPaintPoint(DrawModel point) {
    if (isErasing) {
      // Save the state of paint paths before erasing begins.
      if (value.paintPathsBeforeErasing.isEmpty) {
        value =
            value.copyWith(paintPathsBeforeErasing: value.paintPaths.toList());
      }
      _erase(point);
    } else {
      value = value.copyWith(
        currentPaintPath: value.currentPaintPath.toList()..add(point),
      );
    }
  }

  /// Ends the current drawing or erasing path, updating the state accordingly.
  void endPath() {
    if (!isErasing && value.currentPaintPath.toList().isNotEmpty) {
      value.paintPaths = value.paintPaths.toList()
        ..add(
          List.from(value.currentPaintPath.toList()),
        ); // Save the drawn path.
      addAction(
        ActionDraw(
          paintPath: value.currentPaintPath.toList(),
          listIndex: value.paintPaths.length - 1,
          timestamp: DateTime.now(),
          actionType: ActionType.draw,
        ),
      );
      value.currentPaintPath = value.currentPaintPath.toList()
        ..clear(); // Clear the path.
    } else if (isErasing) {
      addAction(
        ActionErase(
          currentPaintPath: value.paintPaths.toList(),
          lastPaintPath: value.paintPathsBeforeErasing.toList(),
          timestamp: DateTime.now(),
          actionType: ActionType.erase,
        ),
      );
      value = value.copyWith(
        paintPathsBeforeErasing: value.paintPathsBeforeErasing..clear(),
      );
    }
  }

  /// Toggles the erasing mode. If enabled, disables the drawing mode.
  void toggleErasing() {
    isErasing = !isErasing;
    if (isErasing) {
      isDrawing = false;
    }
  }

  /// Toggles the drawing mode. If enabled, disables the erasing mode.
  void toggleDrawing() {
    isDrawing = !isDrawing;
    if (isDrawing) {
      isErasing = false;
    }
  }

  /// Internal method for erasing parts of the canvas.
  void _erase(DrawModel draw) {
    final position = draw.offset;
    final updatedPaths = <List<DrawModel?>>[];

    for (final path in value.paintPaths.toList()) {
      final updatedPath = <DrawModel?>[];

      var isInEraseRegion = false;
      for (var i = 0; i < path.length; i++) {
        final point = path[i];
        if (point == null) continue;

        // Check if the point is within the eraser's region.
        if (((point.offset - position).distance) <
            value.eraseSize + draw.strokeWidth) {
          isInEraseRegion = true;
        }

        if (isInEraseRegion) {
          if (i == 0 ||
              (i > 0 &&
                  (path[i - 1]!.offset - position).distance >=
                      value.eraseSize)) {
            if (updatedPath.isNotEmpty) {
              updatedPaths.add(List.from(updatedPath));
              updatedPath.clear();
            }
            isInEraseRegion = false;
          }
        } else {
          updatedPath.add(point);
        }
      }

      if (updatedPath.isNotEmpty) {
        updatedPaths.add(updatedPath);
      }
    }

    value = value.copyWith(
      paintPaths: updatedPaths,
    ); // Update the state with erased paths.
  }
}
