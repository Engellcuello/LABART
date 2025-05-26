import 'dart:io';
import 'package:http/http.dart' as http;

class ImageDownloader {
  /// Obtener la ruta de descarga según la plataforma
  Future<String> getDownloadPath() async {
    String path = "/storage/emulated/0/Pictures/Labart";
    Directory directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
      print("📁 Carpeta creada en: $path");
    } else {
      print("📂 La carpeta ya existe en: $path");
    }
    return path;
  }

  /// Descargar y guardar una imagen desde una URL
  Future<String> downloadImage(String imageUrl, String fileName) async {
    var response = await http.get(Uri.parse(imageUrl));
    var downloadPath = await getDownloadPath();
    var filePath = '$downloadPath/$fileName';

    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);

    print("Imagen descargada en: $filePath");
    return filePath;
  }
}