import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/features/autentication/screens/login_singup/login_singup.dart';
import 'package:labart/features/settings/screens/admin_account/admin_acount.dart';
import 'package:labart/features/settings/screens/edit_perfil/editar_perfil.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _nombreUsuario = 'Cargando...';
  String _correoUsuario = 'Cargando...';
  String _imagenUrl = 'https://randomuser.me/api/portraits/men/1.jpg';
  bool _cargando = true;
  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idUsuario = prefs.getInt('id_usuario') ?? 0;

      final response = await http.get(
        Uri.parse('${THttpHelper.baseUrl}/usuario/$idUsuario'),
      );

      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        setState(() {
          _nombreUsuario = data['Nombre_usuario'] ?? 'Nombre no disponible';
          _correoUsuario = data['correo_usuario'] ?? 'Correo no disponible';
          _imagenUrl = data['Img_usuario'] ?? 'https://png.pngtree.com/png-clipart/20191120/original/pngtree-outline-user-icon-png-image_5045523.jpg';
          _cargando = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _nombreUsuario = 'Error al cargar';
            _correoUsuario = 'Error al cargar';
            _cargando = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _nombreUsuario = 'Error de conexión';
          _correoUsuario = 'Error de conexión';
          _cargando = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy),
          color: dark ? Colors.white : Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ajustes',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 20),
            _buildSettingsSection('Configuración de cuenta', [
              'Administración de la cuenta',
              'Notificaciones',
              'Privacidad y seguridad',
              'Datos y almacenamiento',
              'Soporte',
            ]),
            const SizedBox(height: 20),
            _buildSettingsSection('Configuración de la app', [
              'Tema',
              'Permisos',
              'Personalización',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(_imagenUrl), // Imagen dinámica
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nombreUsuario, // Nombre dinámico
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  _correoUsuario, // Correo dinámico
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            color: dark ? Colors.white : Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditarPerfilScreen(), // Navegar a la pantalla de edición
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildSettingsSection(String title, List<String> options) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          color: dark ? const Color.fromARGB(255, 37, 37, 37) : const Color.fromARGB(255, 247, 247, 247),
          child: Column(
            children: List.generate(
              options.length,
              (index) => Column(
                children: [
                  ListTile(
                    title: Text(options[index]),
                    trailing: const Icon(Iconsax.arrow_right_3_copy),
                    onTap: () {
                      switch (options[index]) {
                        case 'Administración de la cuenta':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountManagementScreen(),
                            ),
                          );
                          break;
                        case 'Notificaciones':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationsSettingsScreen(),
                            ),
                          );
                          break;
                        case 'Privacidad y seguridad':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacySecurityScreen(),
                            ),
                          );
                          break;
                        case 'Datos y almacenamiento':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DataStorageScreen(),
                            ),
                          );
                          break;
                        case 'Soporte':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SupportScreen(),
                            ),
                          );
                          break;
                        case 'Tema':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ThemeSettingsScreen(),
                            ),
                          );
                          break;
                        case 'Permisos':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PermissionsScreen(),
                            ),
                          );
                          break;
                        case 'Personalización':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PersonalizationScreen(),
                            ),
                          );
                          break;
                      }
                    },
                  ),
                  if (index != options.length - 1)
                    const Divider(height: 1, indent: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Pantallas de configuración

class BaseSettingsScreen extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const BaseSettingsScreen({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ?  Color.fromARGB(255, 37, 37, 37) : Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              width: double.infinity,
              color: dark ? TColors.blakfondo : Colors.white, // Fondo personalizado de la tarjeta
              child: Column(
                children: [
                  // Encabezado fijo dentro de la tarjeta
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color:  dark ? TColors.blakfondo : Colors.white, // mismo fondo del contenido
                      boxShadow: [
                        BoxShadow(
                          color:dark? const Color.fromARGB(179, 255, 255, 255).withOpacity(0.1) : Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Iconsax.arrow_left_2_copy),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(width: 48), // Para equilibrar el ícono de la izquierda
                      ],
                    ),
                  ),

                  // Contenido con scroll
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}


class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettingsScreen(
      title: 'Información personal',
      children: [
        buildSettingsOption(context, 'Fecha de nacimiento', () {}),
        const Divider(),
        buildSettingsOption(context, 'Género', () {}),
        const Divider(),
        buildSettingsOption(context, 'Idioma', () {}),
      ],
    );
  }
}

class NotificationsSettingsScreen extends StatelessWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettingsScreen(
      title: 'Notificaciones',
      children: [
        _buildSwitchOption('Notificaciones push', true),
        const Divider(),
        _buildSwitchOption('Notificaciones por comentario', true),
        const Divider(),
        _buildSwitchOption('Publicación guardada', false),
        const Divider(),
        _buildSwitchOption('Reacciones', true),
      ],
    );
  }
}

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettingsScreen(
      title: 'Privacidad y seguridad',
      children: [
        _buildSwitchOption('Cuenta privada', false),
        const Divider(),
        buildSettingsOption(context, 'Bloquear usuarios', () {}),
        const Divider(),
        _buildSwitchOption('Contenido sensible', true),
        const Divider(),
        buildSettingsOption(context, 'Historial de actividad', () {}),
      ],
    );
  }
}

class DataStorageScreen extends StatelessWidget {
  const DataStorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettingsScreen(
      title: 'Datos y almacenamiento',
      children: [
        _buildSwitchOption('Descargar imágenes solo en Wi-Fi', true),
        const Divider(),
        buildSettingsOption(context, 'Limpiar caché', () {}),
        const Divider(),
        buildSettingsOption(context, 'Administrar almacenamiento', () {}),
        const Divider(),
        _buildSwitchOption('Modo ahorro de datos', false),
      ],
    );
  }
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettingsScreen(
      title: 'Soporte',
      children: [
        buildSettingsOption(context, 'Centro de ayuda', () {}),
        const Divider(),
        buildSettingsOption(context, 'Enviar sugerencias', () {}),
        const Divider(),
        buildSettingsOption(context, 'Reportar un problema', () {}),
        const Divider(),
        buildSettingsOption(context, 'Términos y condiciones', () {}),
        const Divider(),
        buildSettingsOption(context, 'Política de privacidad', () {}),
        const Divider(),
        buildSettingsOption(context, 'Versión de la app: 1.0', () {}),
      ],
    );
  }
}

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettingsScreen(
      title: 'Tema',
      children: [
        _buildRadioOption('Claro', true),
        const Divider(),
        _buildRadioOption('Oscuro', false),
        const Divider(),
        _buildRadioOption('Sistema', false),
      ],
    );
  }
}

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettingsScreen(
      title: 'Permisos',
      children: [
        _buildSwitchOption('Cámara', true),
        const Divider(),
        _buildSwitchOption('Micrófono', false),
        const Divider(),
        _buildSwitchOption('Ubicación', true),
        const Divider(),
        _buildSwitchOption('Notificaciones', true),
      ],
    );
  }
}

class PersonalizationScreen extends StatelessWidget {
  const PersonalizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseSettingsScreen(
      title: 'Personalización',
      children: [
        buildSettingsOption(context, 'Tema', () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ThemeSettingsScreen(),
            ),
          );
        }),
        const Divider(),
        buildSettingsOption(context, 'Idioma', () {}),
        const Divider(),
        _buildSwitchOption('Animaciones', true),
      ],
    );
  }
}

// Widgets auxiliares

Widget buildSettingsOption(BuildContext context, String title, VoidCallback onTap,
    {Color? textColor}) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(color: textColor ?? Theme.of(context).textTheme.bodyLarge?.color),
    ),
    onTap: onTap,  // Remove the parentheses here - just pass the callback
  );
}

Widget _buildSwitchOption(String title, bool value) {
  return StatefulBuilder(
    builder: (context, setState) {
      return SwitchListTile(
        title: Text(title),
        value: value,
        onChanged: (newValue) => setState(() => value = newValue),
        activeColor: Colors.blue,
      );
    },
  );
}

Widget _buildRadioOption(String title, bool selected) {
  return ListTile(
    title: Text(title),
    leading: Radio<bool>(
      value: selected,
      groupValue: true,
      onChanged: (bool? value) {},
      activeColor: Colors.blue,
    ),
    onTap: () {},
  );
}