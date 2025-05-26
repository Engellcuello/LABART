/// A class representing settings for a specific layer in the canvas.
class LayerSettings {
  const LayerSettings({
    required this.title,
    required this.index,
  });

  /// Title of the layer.
  final String title;

  /// Index of the layer, determining its order on the canvas.
  final int index;

  /// Creates a copy of this layer with optional
  /// modifications to its properties.
  LayerSettings copyWith({
    String? title,
    int? index,
  }) {
    return LayerSettings(
      title: title ?? this.title,
      index: index ?? this.index,
    );
  }
}
