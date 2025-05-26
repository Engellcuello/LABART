import 'package:flutter/material.dart';
import 'package:labart/features/explore_more/screens/explorar/categorias/widgtes/cartas/image_card.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:labart/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Map<String, dynamic>> exploreCards = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchExploreData();
  }

  Future<void> _fetchExploreData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('id_usuario') ?? 0;
      
      final response = await http.get(
        Uri.parse('${THttpHelper.baseUrl}/page_explorar/$userId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${prefs.getString('token') ?? ''}",
        },
      );

      if (!mounted) return; // Verificación antes de procesar la respuesta

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          final secciones = data['data']['secciones'] as List;
          
          if (!mounted) return; // Verificación antes de actualizar el estado
          
          setState(() {
            exploreCards = secciones.map((seccion) {
              final publicaciones = seccion['publicaciones'] as List;
              final firstPublication = publicaciones.isNotEmpty ? publicaciones[0] : null;
              
              // Calculate total reactions and comments for all publications in this section
              final totalReactions = publicaciones.fold(0, (sum, p) => sum + (p['total_reacciones'] as int));
              final totalComments = publicaciones.fold(0, (sum, p) => sum + (p['total_comentarios'] as int));
              
              return {
                'imageUrls': publicaciones.map((p) => p['imagen_publicacion'] as String).toList(),
                'title': seccion['titulo_seccion'] as String,
                'subtitle': 'Explora más contenido',
                'totalReactions': totalReactions.toString(),
                'totalComments': totalComments.toString(),
                'userName': firstPublication?['nombre_usuario'] ?? 'Anónimo',
                'userImage': firstPublication?['foto_usuario'], // Puede ser null
                'daysAgo': firstPublication != null 
                  ? _getTimeAgo(firstPublication['fecha_publicacion']) 
                  : 'Recién',
              };
            }).toList();
            isLoading = false;
          });
        } else {
          throw Exception(data['message'] ?? 'Error al cargar datos');
        }
      } else {
        throw Exception('Error de conexión: ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return; // Verificación antes de mostrar el error
      
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  String _getTimeAgo(String isoDate) {
    if (isoDate.isEmpty) return 'Recién';
    
    final dateTime = DateTime.parse(isoDate);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Reciéntemente';
    } else if (difference.inHours < 1) {
      return 'Hace ${difference.inMinutes} minuto${difference.inMinutes == 1 ? '' : 's'}';
    } else if (difference.inDays < 1) {
      return 'Hace ${difference.inHours} hora${difference.inHours == 1 ? '' : 's'}';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} día${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks semana${weeks == 1 ? '' : 's'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months mes${months == 1 ? '' : 'es'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Hace $years año${years == 1 ? '' : 's'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $errorMessage'),
              ElevatedButton(
                onPressed: _fetchExploreData,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              const SizedBox(height: TSizes.spaceBtwItems),
              Column(
                children: exploreCards.map((card) {
                  return Column(
                    children: [
                      ExploreImageCard(
                        imageUrls: card['imageUrls'],
                        title: card['title'],
                        subtitle: card['subtitle'],
                        totalReactions: card['totalReactions'],
                        totalComments: card['totalComments'],
                        userImage: card['userImage'],
                        userName: card['userName'],
                        daysAgo: card['daysAgo'],
                      ),
                      const SizedBox(height: 2),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}