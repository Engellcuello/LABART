import 'package:equatable/equatable.dart';

// Model representing the size of an element with width and height.
class SizeModel extends Equatable {
  // Constructor to initialize the width and height with default values of 0.
  const SizeModel({this.width = 0, this.height = 0});
  // Method to create an empty SizeModel with width and height set to 0.
  factory SizeModel.empty() {
    return const SizeModel();
  }

  final double height; // The height of the element.
  final double width; // The width of the element.

  // Method to create a copy of the current SizeModel
  //with optional new values for width and height.
  SizeModel copyWith({double? width, double? height}) {
    return SizeModel(
      width: width ??
          this.width, // Use the provided width value or keep the current one.
      height: height ??
          this.height, // Use the provided height value or keep the current one.
    );
  }

  // Overriding the props getter to include
  // width and height for equality comparison.
  @override
  List<Object?> get props =>
      [width, height]; // Properties for equality comparison.
}
