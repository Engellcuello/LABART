import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:labart/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<ApiResponse> verifyCurrentPassword(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id_usuario');

    try {
      final response = await http.post(
        Uri.parse('${THttpHelper.baseUrl}/verify_current_password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'current_password': password,
          'user_id': userId, // <- lo agregamos aquí
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: data['message'],
          userId: data['user_id']?.toInt(),
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['error'] ?? 'Error desconocido',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error de conexión: $e',
      );
    }
  }

  static Future<ApiResponse> changePassword({
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${THttpHelper.baseUrl}/change_password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'current_password': currentPassword,
          'new_password': newPassword,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          message: data['message'],
        );
      } else {
        return ApiResponse(
          success: false,
          message: data['error'] ?? 'Error desconocido',
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Error de conexión: $e',
      );
    }
  }
}

class ApiResponse {
  final bool success;
  final String? message;
  final int? userId;

  ApiResponse({
    required this.success,
    this.message,
    this.userId,
  });
}