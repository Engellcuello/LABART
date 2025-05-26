import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; 
class THttpHelper { 
  //aqui va el link del backend
  static const String baseUrl = 'https://uniquely-holy-clam.ngrok-free.app/'; 
  
  // Helper method to make a GET request 
  static Future<Map<String, dynamic>> get(String endpoint) async { 
    final response = await http.get(Uri.parse('$baseUrl/$endpoint')); 
    return _handleResponse(response); 
  } 


  static Future<Map<String, dynamic>> post(String endpoint, dynamic data) async { 
  final response = await http.post( 
  Uri.parse('$baseUrl/$endpoint'), 
  headers: {'Content-Type': 'application/json'}, 
  body: json.encode(data), 
  ); 
  return _handleResponse (response); 
  } 
  // Helper method to make a PUT request 
  static Future<Map<String, dynamic>> put(String endpoint, dynamic data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete (String endpoint) async { 
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint')); 
    return _handleResponse (response); 
  } 
  
  // Handle the HTTP response 
  static Map<String, dynamic> _handleResponse(http.Response response) { 
    if (response.statusCode == 200) { 
      return json.decode(response.body); 
    } else { 
      throw Exception('Failed to load data: ${response.statusCode}'); 
    } 
  }
}

class PublicacionServices {
  static Future<bool> eliminarPublicacion({required int id}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        throw Exception('Token no encontrado');
      }

      final uri = Uri.parse('${THttpHelper.baseUrl}/publicacion/$id');

      final response = await http.delete(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
        return false;
    }
  }

  static Future<bool> actualizarPublicacion({
    required int id,
    required String titulo,
    required String descripcion,
    required bool esExplicita,
    required String imagenUrl,
    required int idusuario,
    required List<String> etiquetas,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      if (token.isEmpty) {
        throw Exception('Token no encontrado');
      }

      final uri = Uri.parse('${THttpHelper.baseUrl}/publicacion/$id');

      final body = jsonEncode({
        'Titulo_publicacion': titulo,
        'Descripcion_publicacion': descripcion,
        'Cont_Explicit_publi': esExplicita,
        'Img_publicacion': imagenUrl,
        'ID_usuario': idusuario,
        'etiquetas': etiquetas,
      });

      debugPrint(body); // ✅ Ahora sí imprime correctamente

      final response = await http.put(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al actualizar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
    }
  }
}


String formatUsername(String username) {
  return username.replaceAll(' ', '_');
}

Future<Map<String, dynamic>> fetchUserData(int userId, String token) async {
  try {
    final userFuture = http.get(
      Uri.parse('${THttpHelper.baseUrl}/usuario/$userId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final statsFuture = http.get(
      Uri.parse('${THttpHelper.baseUrl}/estadisticas_usuario/$userId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    final responses = await Future.wait([userFuture, statsFuture]);

    final userData = json.decode(responses[0].body);
    final statsData = json.decode(responses[1].body);

    // Verificar si hay imagen de usuario
    final userImage = userData['Img_usuario']?.toString().trim();
    final hasImage = userImage != null && userImage.isNotEmpty;

    return {
      'username': formatUsername(userData['Nombre_usuario']),
      'fullName': userData['Nombre_usuario'],
      'postsCount': statsData['total_publicaciones'] ?? 0,
      'imageUrl': hasImage ? userImage : null, // Devuelve null si no hay imagen
      'followersCount': 0,
      'followingCount': 0,
      'userImage': hasImage ? userImage : null, // Devuelve null si no hay imagen
    };
  } catch (e) {
    print('Error fetching user data: $e');
    throw Exception('Failed to load user data');
  }
}