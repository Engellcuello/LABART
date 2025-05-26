  import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
  import 'package:http/http.dart' as http;
  import 'dart:convert';
  import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/navigation_bar.dart';
import 'package:labart/widgets/profile_page.dart';
  import 'package:shared_preferences/shared_preferences.dart';

  class TopUsersScreen extends StatefulWidget {
    const TopUsersScreen({Key? key}) : super(key: key); // Se agrega el parámetro 'key'

    @override
    _TopUsersScreenState createState() => _TopUsersScreenState();
  }

  class _TopUsersScreenState extends State<TopUsersScreen> {
    List<dynamic> _users = [];
    bool _isLoading = true;
    String _errorMessage = '';

    @override
    void initState() {
      super.initState();
      _fetchTopUsers();
    }

    Future<void> _fetchTopUsers() async {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token') ?? '';
        final response = await http.get(
          Uri.parse('${THttpHelper.baseUrl}/usuarios/top'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            _users = data['usuarios'] as List;
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = 'Error al cargar los usuarios: ${response.statusCode}';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error de conexión: $e';
          _isLoading = false;
        });
      }
    }

    Widget _buildUserCard(Map<String, dynamic> user, BuildContext context) {
      return GestureDetector(
        onTap: () async {
          // Obtener el ID del usuario actual desde SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          final currentUserId = prefs.getInt('id_usuario');
          final cardUserId = user['ID_usuario']; // Asumiendo que el user tiene un campo 'id'

          if (currentUserId == cardUserId) {
            // Si es el mismo usuario, navegar a ProfilePage()
            // Asumo que tienes una forma de navegar a tu perfil propio
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          } else {
            // Si es otro usuario, navegar a UserProfilePageWrapper
            NavigationController.to.pushPage(
              UserProfilePageWrapper(
                userId: cardUserId,
                userName: user['Nombre_usuario'],
                userImg: user['Img_usuario'],
              ),
            );
          }
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Resto del código de tu tarjeta permanece igual...
                Positioned.fill(
                  child: Image.network(
                    user['Img_usuario'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color.fromARGB(255, 250, 250, 250),
                      child: Icon(Icons.person, size: 60, color: Colors.black),
                    ),
                  ),
                ),

            // Degradado en la parte inferior
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 70,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Información encima del degradado
            Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Nombre y publicaciones
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user['Nombre_usuario'] ?? 'Usuario',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14, // más pequeño
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        '${user['total_publicaciones']} publicaciones',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11, // más pequeño
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Total de vistas
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white54, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.remove_red_eye, color: Colors.white, size: 14),
                      SizedBox(width: 3),
                      Text(
                        '${user['total_vistas']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ],
        ),
      ),
      )
    );
  }



    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Usuarios Destacados'),
          centerTitle: true,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : _users.isEmpty
                    ? Center(child: Text('No hay usuarios disponibles'))
                    : GridView.builder(
                        padding: EdgeInsets.all(2),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemCount: _users.length,
                        itemBuilder: (context, index) {
                          return _buildUserCard(_users[index], context); // ← aquí el cambio
                        },
                      ),
      );
    }
  }