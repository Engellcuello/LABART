import 'package:flutter/material.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/navigation_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Categoria {
  final int id;
  final String nombre;
  final String descripcion;
  final String imagenUrl;

  Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['ID_categoria'],
      nombre: json['Nombre_categoria'],
      descripcion: json['Descripcion_categoria'],
      imagenUrl: json['Img_categoria'],
    );
  }
}

class CategoriaGridScreen extends StatefulWidget {
  const CategoriaGridScreen({Key? key}) : super(key: key);

  @override
  State<CategoriaGridScreen> createState() => _CategoriaGridScreenState();
}

class _CategoriaGridScreenState extends State<CategoriaGridScreen> {
  late Future<List<Categoria>> categoriasFuture;

  Future<List<Categoria>> fetchCategorias() async {
    final response = await http.get(Uri.parse('${THttpHelper.baseUrl}/categoria'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => Categoria.fromJson(e)).toList();
    } else {
      throw Exception('Fallo la carga de categorías');
    }
  }

  @override
  void initState() {
    super.initState();
    categoriasFuture = fetchCategorias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(3),
        child: FutureBuilder<List<Categoria>>(
          future: categoriasFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No hay categorías disponibles'));
            }

            final categorias = snapshot.data!;

            return SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: categorias.asMap().entries
                          .where((entry) => entry.key.isEven)
                          .map((entry) => GestureDetector(
                                onTap: () => _navigateToPublicacionesCategoria(context, entry.value),
                                child: _buildCategoriaCard(entry.value),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Column(
                      children: categorias.asMap().entries
                          .where((entry) => entry.key.isOdd)
                          .map((entry) => GestureDetector(
                                onTap: () => _navigateToPublicacionesCategoria(context, entry.value),
                                child: _buildCategoriaCard(entry.value),
                              ))
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

   void _navigateToPublicacionesCategoria(BuildContext context, Categoria categoria) {
    NavigationController.to.openCategoriaScreen(
      categoria.id,
      categoria.nombre,
    );
  }

  Widget _buildCategoriaCard(Categoria categoria) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.network(
              categoria.imagenUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: TSizes.sm,
              left: TSizes.sm,
              right: TSizes.sm,
              child: Text(
                categoria.nombre,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




