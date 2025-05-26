import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

class ImageService {
  static Future<Uint8List> rotateImage(
    Uint8List imageBytes,
    double angle,
  ) async {
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frameInfo = await codec.getNextFrame();
    final image = frameInfo.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final s = sin(angle);
    final c = cos(angle);

    final width = image.width.toDouble();
    final height = image.height.toDouble();

    final newWidth = (width * c).abs() + (height * s).abs();
    final newHeight = (width * s).abs() + (height * c).abs();

    canvas
      ..translate(newWidth / 2, newHeight / 2)
      ..rotate(angle)
      ..translate(-width / 2, -height / 2)
      ..drawImage(image, Offset.zero, Paint());

    final picture = recorder.endRecording();
    final rotatedImage =
        await picture.toImage(newWidth.ceil(), newHeight.ceil());
    final byteData =
        await rotatedImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
