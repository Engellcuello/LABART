import 'package:equatable/equatable.dart';
import 'package:labart/features/paint_drawing/lib/src/controllers/settings/layer_settings.dart';
import 'package:labart/features/paint_drawing/lib/src/helpers/random_service.dart';
import 'package:labart/features/paint_drawing/lib/src/models/position_model.dart';
import 'package:labart/features/paint_drawing/lib/src/models/size_model.dart';

// Represents a generic item that can be added to the painter canvas.
class PainterItem extends Equatable {
  PainterItem({
    required this.position, // The position of the item on the canvas.
    required this.layer, // The layer settings for the item.
    this.size, // The size of the item, if applicable.
    this.enabled =
        true, // Indicates if the item is enabled (visible and active).
    this.rotation = 0, // The rotation angle of the item in degrees.
    String? id, // Unique identifier for the item, generated if not provided.
  }) : id = id ?? RandomService.generateRandomId();

  final String id; // Unique identifier for the item.
  final bool enabled; // Indicates whether the item is active.
  final PositionModel position; // The item's position on the canvas.
  final SizeModel? size; // Optional size information for the item.
  final double rotation; // Rotation angle in degrees.
  final LayerSettings layer; // Layer settings for the item.

  PainterItem copyWith({
    bool? enabled, // New enabled state, if provided.
    PositionModel? position, // New position, if provided.
    LayerSettings? layer, // New layer settings, if provided.
    SizeModel? size, // New size, if provided.
    double? rotation, // New rotation angle, if provided.
  }) {
    return PainterItem(
      id: id,
      enabled: enabled ?? this.enabled,
      position: position ?? this.position,
      layer: layer ?? this.layer,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  List<Object?> get props => [id, enabled, position, size, rotation];
}
