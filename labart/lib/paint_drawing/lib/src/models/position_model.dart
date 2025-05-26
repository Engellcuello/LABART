import 'package:equatable/equatable.dart';

// Model representing a position with x and y coordinates.
class PositionModel extends Equatable {
  // Constructor to initialize the x and y values with default values of 0.
  const PositionModel({this.x = 0, this.y = 0});

  final double y; // The y-coordinate of the position.
  final double x; // The x-coordinate of the position.

  // Method to create a copy of the current PositionModel
  // with optional new values for x and y.
  PositionModel copyWith({double? x, double? y}) {
    return PositionModel(
      x: x ?? this.x, // Use the provided x value or keep the current one.
      y: y ?? this.y, // Use the provided y value or keep the current one.
    );
  }

  // Overriding the props getter to include x and y for equality comparison.
  @override
  List<Object?> get props => [x, y]; // Properties for equality comparison.
}
