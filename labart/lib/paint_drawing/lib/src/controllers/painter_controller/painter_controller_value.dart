part of 'painter_controller.dart';

/// This class is used to hold the values for the PainterController.
/// It manages the state of the drawing application, including settings,
/// drawn paths, selected items, and tool properties.
class PainterControllerValue {
  /// Constructor to initialize the controller's values.
  PainterControllerValue({
    required this.settings,
    this.paintPaths = const <List<DrawModel?>>[],
    this.currentPaintPath = const <DrawModel?>[],
    this.paintPathsBeforeErasing = const <List<DrawModel?>>[],
    this.items = const <PainterItem>[],
    this.selectedItem,
    this.brushSize = 5,
    this.eraseSize = 5,
    this.brushColor = Colors.blue,
  });

  /// General painter settings.
  final PainterSettings settings;

  /// List of all paint paths (each path is a list of draw models).
  List<List<DrawModel?>> paintPaths = <List<DrawModel?>>[];

  /// The current paint path being drawn (not yet finalized).
  List<DrawModel?> currentPaintPath = <DrawModel?>[];

  /// List of paint paths before erasing (for undo/redo support).
  List<List<DrawModel?>> paintPathsBeforeErasing = <List<DrawModel?>>[];

  /// List of all items (shapes, images, text) on the canvas.
  List<PainterItem> items = <PainterItem>[];

  /// The currently selected item, if any.
  PainterItem? selectedItem;

  /// The size of the brush tool.
  final double brushSize;

  /// The size of the eraser tool.
  final double eraseSize;

  /// The color of the brush tool.
  final Color brushColor;

  /// Creates a copy of the current controller value with optional changes.
  PainterControllerValue copyWith({
    PainterSettings? settings,
    List<List<DrawModel?>>? paintPaths,
    List<DrawModel?>? currentPaintPath,
    List<List<DrawModel?>>? paintPathsBeforeErasing,
    List<PainterItem>? items,
    PainterItem? selectedItem,
    double? brushSize,
    double? eraseSize,
    Color? brushColor,
  }) {
    return PainterControllerValue(
      settings: settings ?? this.settings,
      paintPaths: paintPaths ?? this.paintPaths,
      currentPaintPath: currentPaintPath ?? this.currentPaintPath,
      paintPathsBeforeErasing:
          paintPathsBeforeErasing ?? this.paintPathsBeforeErasing,
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,
      brushSize: brushSize ?? this.brushSize,
      eraseSize: eraseSize ?? this.eraseSize,
      brushColor: brushColor ?? this.brushColor,
    );
  }
}
