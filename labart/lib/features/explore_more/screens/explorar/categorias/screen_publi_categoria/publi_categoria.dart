import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labart/utils/helpers/helper_functions.dart';
import 'dart:convert';
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/common/models/publicacion_model.dart';
import 'package:labart/widgets/navigation_bar.dart';

class PublicacionesCategoriaScreen extends StatefulWidget {
  final int categoriaId;
  final String nombreCategoria;

  const PublicacionesCategoriaScreen({
    Key? key, 
    required this.categoriaId,
    required this.nombreCategoria,
  }) : super(key: key);

  @override
  State<PublicacionesCategoriaScreen> createState() => _PublicacionesCategoriaScreenState();
}

class _PublicacionesCategoriaScreenState extends State<PublicacionesCategoriaScreen> {
  late Future<List<Publicacion>> publicacionesFuture;
  late String nombreCategoria;
  final List<Publicacion> _publicaciones = []; // Lista para almacenar las publicaciones

  @override
  void initState() {
    super.initState();
    nombreCategoria = widget.nombreCategoria;
    publicacionesFuture = fetchPublicacionesPorCategoria();
  }

  Future<List<Publicacion>> fetchPublicacionesPorCategoria() async {
    final response = await http.get(
      Uri.parse('${THttpHelper.baseUrl}/publicacion_categoria/categoria/${widget.categoriaId}'),
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final publicaciones = jsonList.map((e) => Publicacion.fromJson(e)).toList();
      _publicaciones.addAll(publicaciones); // Almacenamos las publicaciones
      return publicaciones;
    } else {
      throw Exception('Failed to load publications');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: dark ? Colors.white : Colors.black),
          onPressed: () => NavigationController.to.popPage(),
        ),
        title: Text(
          nombreCategoria,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: FutureBuilder<List<Publicacion>>(
          future: publicacionesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay publicaciones disponibles'));
            }

            return SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: _publicaciones.asMap().entries
                          .where((entry) => entry.key.isEven)
                          .map((entry) => _buildPublicacionCard(entry.value, dark))
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Column(
                      children: _publicaciones.asMap().entries
                          .where((entry) => entry.key.isOdd)
                          .map((entry) => _buildPublicacionCard(entry.value, dark))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPublicacionCard(Publicacion publicacion, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: GestureDetector(
        onTap: () {
          if (publicacion.id > 0) {
            NavigationController.to.openDetail(
              publicacion,
              isDark,
              _publicaciones,
            );
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Hero(
            tag: publicacion.imagenUrl,
            child: Image.network(
              publicacion.imagenUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => 
                Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                ),
            ),
          ),
        ),
      ),
    );
  }
}