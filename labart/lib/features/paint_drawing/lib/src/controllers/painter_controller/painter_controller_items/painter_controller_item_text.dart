part of '../painter_controller.dart';

extension PainterControllerItemText on PainterController {
  /// Adds a text item to the painting canvas.
  Future<void> addText(String text, {String? layerTitle}) async {
    if (text.isNotEmpty) {
      final painterItem = TextItem(
        position: const PositionModel(),
        text: text,
        layer: LayerSettings(
          title: layerTitle ??
              'Text (${value.items.whereType<TextItem>().length})',
          index: value.items.length,
        ),
      ).copyWith(
        textStyle: value.settings.text?.textStyle,
        textAlign: value.settings.text?.textAlign,
        enableGradientColor: value.settings.text?.enableGradientColor,
        gradientStartColor: value.settings.text?.gradientStartColor,
        gradientEndColor: value.settings.text?.gradientEndColor,
        gradientBegin: value.settings.text?.gradientBegin,
        gradientEnd: value.settings.text?.gradientEnd,
      );
      value = value.copyWith(
        items: value.items.toList()..insert(0, painterItem),
      );

      addAction(
        ActionAddItem(
          item: painterItem,
          listIndex: value.items.length - 1,
          timestamp: DateTime.now(),
          actionType: ActionType.addedTextItem,
        ),
      );
      value.selectedItem = painterItem;
    }
  }
}
