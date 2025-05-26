/// A class containing settings for the eraser tool.
class EraseSettings {
  const EraseSettings({
    required this.size,
  });

  /// Size of the eraser.
  final double size;

  /// Creates a copy of this eraser settings with an
  /// optional modification to its size.
  EraseSettings copyWith({
    double? size,
  }) {
    return EraseSettings(
      size: size ?? this.size,
    );
  }
}
