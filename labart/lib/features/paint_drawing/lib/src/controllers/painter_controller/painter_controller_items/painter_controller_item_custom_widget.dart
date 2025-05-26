part of '../painter_controller.dart';

extension PainterControllerItemCustomWidget on PainterController {
  /// Adds an image to the painter as a new item, using the provided Uint8List.
  /// The image is inserted at the top of the
  /// items list, and an action is logged.
  void addCustomWidget(Widget widget, {String? layerTitle}) {
    final painterItem = CustomWidgetItem(
      position: const PositionModel(),
      widget: widget,
      layer: LayerSettings(
        title: layerTitle ??
            '''Custom Widget (${value.items.whereType<CustomWidgetItem>().length})''',
        index: value.items.length,
      ),
      size: const SizeModel(width: 100, height: 100),
    );
    value = value.copyWith(
      items: value.items.toList()..insert(0, painterItem),
    );
    addAction(
      ActionAddItem(
        item: painterItem,
        listIndex: value.items.length - 1,
        timestamp: DateTime.now(),
        actionType: ActionType.addedCustomWidgetItem,
      ),
    );
    value.selectedItem = painterItem;
  }
}
