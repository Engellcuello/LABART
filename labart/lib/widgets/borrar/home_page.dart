import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labart/common/dialogs/succes_screen/success_dialog.dart';
import 'dart:io';
import 'package:labart/common/functions/Function_downloads/descargar_imagen.dart';
import 'package:labart/widgets/borrar/app_bar.dart';
import 'package:labart/widgets/borrar/primary_btn.dart';

class MyHomePagesd extends StatefulWidget {
  const MyHomePagesd({super.key, required this.title});
  final String title;

  @override
  _MyHomePagesdState createState() => _MyHomePagesdState();
}

class _MyHomePagesdState extends State<MyHomePagesd> with SingleTickerProviderStateMixin {
  File? _imageFile;
  final ImageDownloader _imageDownloader = ImageDownloader();

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(appBarTitle: widget.title),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_imageFile != null)
              Image.file(_imageFile!, height: 200, width: 200, fit: BoxFit.cover),
            const SizedBox(height: 20),
            PrimaryBtn(
              btnFun: () => _getFromGallery(),
              btnText: 'Pick Image',
            ),
            const SizedBox(height: 20),
            PrimaryBtn(
              btnFun: () => _downloadRandomImage(context),
              btnText: 'Download Random Image',
            ),
          ],
        ),
      ),
    );
  }

  /// Obtener imagen desde la galería
  _getFromGallery() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('¡Ocurrió una excepción al seleccionar la imagen!');
    }
  }

  /// Descargar y guardar una imagen aleatoria con animación de confirmación
  _downloadRandomImage(BuildContext context) async {
    try {
      final filePath = await _imageDownloader.downloadImage(
        'https://picsum.photos/200/300',
        'random_image_${DateTime.now().millisecondsSinceEpoch}.jpg', // Nombre único
      );

      setState(() {
        _imageFile = File(filePath); // Asigna el archivo descargado
      });

      _showSuccessDialog(context); // Muestra animación de éxito

    } catch (e) {
      print('¡Error en la descarga: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar: ${e.toString()}')),
      );
    }
  }

  /// Mostrar diálogo con animación pop-out y Rive
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const SuccessDialog(),
    );
  }
}
