import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:labart/common/dialogs/succes_screen/success_dialog.dart';
import 'package:labart/common/functions/Function_downloads/descargar_imagen.dart';

class DescargarImagenHandler {
  final String imageUrl;
  final String nom_usuario;
  final String titulo;
  final ImageDownloader _imageDownloader = ImageDownloader();

  DescargarImagenHandler(this.imageUrl, this.nom_usuario, this.titulo);

    Future<void> descargarImagen(BuildContext context, Function(File)? onSuccess) async {
    debugPrint('URL de imagen: $imageUrl');
    debugPrint('Nombre de usuario: $nom_usuario');
    debugPrint('Fecha de publicación: $titulo');
    
    final fecha = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd_HH-mm-ss').format(fecha);
    final fileName = 'Labart_${nom_usuario}_${titulo}_$formattedDate.jpg';

    try {
      final filePath = await _imageDownloader.downloadImage(imageUrl, fileName);
      final imageFile = File(filePath);
      onSuccess?.call(imageFile);

      // Usar un contexto válido después de la espera
      _showSuccessDialog(context); 

    } catch (e) {
      debugPrint('Error en la descarga: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al descargar: ${e.toString()}')),
        );
      }
    }
  }


  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const SuccessDialog(),
    );
  }
}