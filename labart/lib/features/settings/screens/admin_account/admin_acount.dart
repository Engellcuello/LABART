import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labart/features/autentication/screens/login_singup/login_singup.dart';
import 'package:labart/features/settings/screens/admin_account/screens/choose_password.dart';
import 'package:labart/features/settings/setting_screen.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para jsonEncode

class AccountManagementScreen extends StatefulWidget {
  const AccountManagementScreen({super.key});

  @override
  _AccountManagementScreenState createState() =>
      _AccountManagementScreenState();
}

class _AccountManagementScreenState extends State<AccountManagementScreen> {
  bool _showDeleteSheet = false;

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('id_usuario'); // si también quieres eliminar esto
    // Luego lo mandas al login (AuthScreen), borrando todo lo anterior
    Get.offAll(() => AuthScreen()); // Si usas GetX
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => AuthScreen()), (route) => false); // Si NO usas GetX
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    final dark = THelperFunctions.isDarkMode(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Ancho del contenedor
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: dark ? TColors.blakfondo : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '¿Eliminar cuenta?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                '¿Estás seguro de que deseas eliminar tu cuenta? Esta accion eliminara todas tus publicaciones, reacciones y comentarios.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón Cancelar
                  SizedBox(
                    width: 110,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: dark ? Colors.white : Colors.black), // Borde negro
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                          color: dark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Botón Eliminar
                  SizedBox(
                    width: 110, // Botón más ancho
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15), 
                        backgroundColor: Colors.transparent, 
                        disabledForegroundColor: Colors.transparent.withOpacity(0.38), disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
                        side: const BorderSide(color: Colors.transparent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.transparent,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                        // Degradado en el botón de eliminar
                        elevation: 5,
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(157, 100, 180, 246),
                              Color.fromARGB(255, 219, 77, 255),
                              Color.fromARGB(159, 211, 170, 212),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Eliminar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirm == true) {
      await _deleteAccount(context);
    }
  }


  Future<void> _deleteAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id_usuario');
    final token = prefs.getString('token');
    
    if (userId != null && token != null) {
      try {
        final response = await http.delete(
          Uri.parse('${THttpHelper.baseUrl}/usuario/$userId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        
        if (response.statusCode == 200) {
          // Eliminar también los datos locales
          await prefs.remove('token');
          await prefs.remove('id_usuario');
          
          // Mostrar mensaje y redirigir al inicio
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cuenta eliminada correctamente')),
          );
          
          // Redirigir a la pantalla de inicio de sesión
          Get.offAll(() => AuthScreen());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de conexión: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener la información del usuario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseSettingsScreen(
      title: 'Administración de cuenta',
      children: [
        buildSettingsOption(context, 'Información personal', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PersonalInfoScreen(),
            ),
          );
        }),
        const Divider(),
        buildSettingsOption(context, 'Cambiar contraseña', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
          );
        }),
        const Divider(),
        buildSettingsOption(context, 'Cerrar sesión', () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('¿Cerrar sesión?'),
              content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ElevatedButton(
                  child: const Text('Cerrar sesión'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          );

          if (confirm == true) {
            logout(context);
          }
        }),
        const Divider(),
        buildSettingsOptionred(context, 'Eliminar cuenta', () {
          _showDeleteConfirmationDialog(context);
        }),
      ],
    );
  }

  Widget buildSettingsOption(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
  Widget buildSettingsOptionred(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.red,
          ),
    ),
      onTap: onTap,
    );
  }
}