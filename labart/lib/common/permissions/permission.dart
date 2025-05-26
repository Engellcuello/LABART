import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermisosHandler {
  // Verificar permisos para subir publicaciones (necesita acceso a galería)
  static Future<bool> verificarPermisosSubirPublicaciones() async {
    if (Platform.isAndroid) {
      // En Android 13+ necesitamos permisos de fotos/videos
      if (await Permission.photos.request().isGranted) {
        return true;
      }
      
      // Para versiones anteriores o si el permiso de fotos no está disponible
      final status = await Permission.storage.status;
      if (status.isGranted) {
        return true;
      } else {
        final result = await Permission.storage.request();
        return result.isGranted;
      }
    } else if (Platform.isIOS) {
      // En iOS solo necesitamos permiso de la galería de fotos
      final status = await Permission.photos.status;
      if (status.isGranted) {
        return true;
      } else {
        final result = await Permission.photos.request();
        return result.isGranted;
      }
    }
    
    // Para otras plataformas asumimos que tiene permisos
    return true;
  }

  // Verificar permisos para descargar imágenes (necesita almacenamiento)
  static Future<bool> verificarPermisosDescargarImagenes() async {
    if (Platform.isAndroid) {
      // En Android 10+ necesitamos permisos de almacenamiento externo
      final status = await Permission.storage.status;
      if (status.isGranted) {
        return true;
      } else {
        final result = await Permission.storage.request();
        return result.isGranted;
      }
    } else if (Platform.isIOS) {
      // En iOS no se necesitan permisos especiales para descargar a directorio temporal
      return true;
    }
    
    // Para otras plataformas asumimos que tiene permisos
    return true;
  }

  // Método para abrir configuración de la app si se deniegan permisos
  static Future<void> abrirConfiguracionApp() async {
    await openAppSettings();
  }

  // Verificar si los permisos fueron denegados permanentemente
  static Future<bool> permisosDenegadosPermanentemente() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      return status.isPermanentlyDenied;
    } else if (Platform.isIOS) {
      final status = await Permission.photos.status;
      return status.isPermanentlyDenied;
    }
    return false;
  }
}