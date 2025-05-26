import 'dart:typed_data';

class RenderItem {
  RenderItem({
    this.itemId,
    this.enableRotation = false,
    this.containerItemId,
    this.image,
  });
  final String? itemId;
  final bool enableRotation;
  final String? containerItemId;
  Uint8List? image;
  bool get isEqualToContainerItemId => containerItemId == itemId;

  RenderItem copyWith({
    String? itemId,
    bool? enableRotation,
    String? containerItemId,
    Uint8List? image,
  }) {
    return RenderItem(
      itemId: itemId ?? this.itemId,
      enableRotation: enableRotation ?? this.enableRotation,
      containerItemId: containerItemId ?? this.containerItemId,
      image: image ?? this.image,
    );
  }
}
