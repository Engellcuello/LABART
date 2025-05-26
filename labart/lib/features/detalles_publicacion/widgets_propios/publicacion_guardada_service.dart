import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PublicacionGuardadaService {
  final String baseUrl;
  final int publicacionId;
  final int usuarioId;
  final String token;

  PublicacionGuardadaService({
    required this.baseUrl,
    required this.publicacionId,
    required this.usuarioId,
    required this.token,
  });

  Future<bool> verificarSiEstaGuardada() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/publicacion_guardada'),
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final publicacionesGuardadas = jsonDecode(response.body) as List;
        return publicacionesGuardadas.any((pg) => 
          pg['ID_publicacion'] == publicacionId && pg['ID_usuario'] == usuarioId);
      }
      return false;
    } catch (e) {
      throw Exception('Error al verificar publicación guardada: $e');
    }
  }

  Future<bool> guardarPublicacion() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/publicacion_guardada'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'ID_usuario': usuarioId,
          'ID_publicacion': publicacionId,
        }),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Error al guardar publicación: $e');
    }
  }

  Future<bool> eliminarPublicacionGuardada() async {
    try {
      // Primero necesitamos obtener el ID del registro guardado
      final responseList = await http.get(
        Uri.parse('$baseUrl/publicacion_guardada'),
        headers: {"Authorization": "Bearer $token"},
      ).timeout(const Duration(seconds: 10));

      if (responseList.statusCode == 200) {
        final publicacionesGuardadas = jsonDecode(responseList.body) as List;
        final publicacionGuardada = publicacionesGuardadas.firstWhere(
          (pg) => pg['ID_publicacion'] == publicacionId && pg['ID_usuario'] == usuarioId,
          orElse: () => null,
        );

        if (publicacionGuardada != null) {
          final responseDelete = await http.delete(
            Uri.parse('$baseUrl/publicacion_guardada/${publicacionGuardada['ID_publicacion_guardada']}'),
            headers: {"Authorization": "Bearer $token"},
          ).timeout(const Duration(seconds: 10));

          return responseDelete.statusCode == 200;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Error al eliminar publicación guardada: $e');
    }
  }

  static Future<PublicacionGuardadaService> crear(
    int publicacionId, {
    required String baseUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('id_usuario') ?? 0;
    final token = prefs.getString('token') ?? '';

    return PublicacionGuardadaService(
      baseUrl: baseUrl,
      publicacionId: publicacionId,
      usuarioId: idUsuario,
      token: token,
    );
  }
}