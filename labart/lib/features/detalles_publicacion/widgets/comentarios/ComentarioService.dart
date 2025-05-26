import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:labart/common/models/comentarios_model.dart';
import 'package:labart/common/models/publicacion_model.dart' show Usuario;
import 'package:shared_preferences/shared_preferences.dart';

class ComentarioService {
  final String baseUrl;

  ComentarioService({required this.baseUrl});

  Future<List<ComentarioConUsuario>> getComentariosPorPublicacion(int publicacionId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    
    final response = await http.get(
      Uri.parse('$baseUrl/comentario?publicacionId=$publicacionId'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> comentariosJson = json.decode(response.body);
      return comentariosJson.map((json) {
        return ComentarioConUsuario(
          comentario: Comentario.fromJson(json),
          usuario: Usuario.fromJson(json['usuario']),
        );
      }).toList();
    } else {
      throw Exception('Error al cargar comentarios');
    }
  }

  Future<Comentario> crearComentario({
    required String contenido,
    required int usuarioId,
    required int publicacionId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    
    final response = await http.post(
      Uri.parse('$baseUrl/comentario'),
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token"
      },
      body: json.encode({
        'Contenido_comentario': contenido,
        'ID_usuario': usuarioId,
        'ID_publicacion': publicacionId,
      }),
    );

    if (response.statusCode == 200) {
      return Comentario.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear comentario: ${response.body}');
    }
  }

  Future<void> eliminarComentario(int comentarioId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    
    final response = await http.delete(
      Uri.parse('$baseUrl/comentario/$comentarioId'),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar comentario: ${response.body}');
    }
  }
}