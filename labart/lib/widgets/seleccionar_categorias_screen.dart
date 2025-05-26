import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/widgets/categoria_service.dart';
import 'package:labart/widgets/categoria_model.dart';

class SeleccionarCategoriasScreen extends StatefulWidget {
  final List<Categoria> categoriasSeleccionadas;
  
  const SeleccionarCategoriasScreen({
    Key? key,
    required this.categoriasSeleccionadas,
  }) : super(key: key);

  @override
  _SeleccionarCategoriasScreenState createState() => _SeleccionarCategoriasScreenState();
}

class _SeleccionarCategoriasScreenState extends State<SeleccionarCategoriasScreen> {
  List<Categoria> categorias = []; 
  late List<Categoria> categoriasSeleccionadas;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    categoriasSeleccionadas = List.from(widget.categoriasSeleccionadas);
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    try {
      final fetchedCategorias = await CategoriaService.fetchCategorias();
      setState(() {
        categorias = fetchedCategorias.map((cat) {
          final isSelected = categoriasSeleccionadas.any((selected) => selected.id == cat.id);
          return cat..seleccionada = isSelected;
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar categorías: $e')),
      );
    }
  }

  void _toggleSeleccion(Categoria categoria) {
    setState(() {
      categoria.seleccionada = !categoria.seleccionada;
      if (categoria.seleccionada) {
        if (!categoriasSeleccionadas.any((c) => c.id == categoria.id)) {
          categoriasSeleccionadas.add(categoria);
        }
      } else {
        categoriasSeleccionadas.removeWhere((c) => c.id == categoria.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    final filteredCategorias = CategoriaService.filtrarCategorias(
      categorias, 
      searchQuery
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy),
          onPressed: () {
            Navigator.pop(context, categoriasSeleccionadas);
          },
        ),
        title: const Text('Selecciona Categorías'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar categorías...',
                prefixIcon: const Icon(Iconsax.search_normal_1_copy),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            // ignore: unnecessary_null_comparison
            child: categorias == null
              ? const Center(child: CircularProgressIndicator())
              : filteredCategorias.isEmpty
                ? const Center(child: Text('No se encontraron categorías'))
                : _buildCategoriasGrid(filteredCategorias),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriasGrid(List<Categoria> categorias) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: categorias.asMap().entries
                  .where((entry) => entry.key.isEven)
                  .map((entry) => _buildCategoriaCard(entry.value))
                  .toList(),
            ),
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Column(
              children: categorias.asMap().entries
                  .where((entry) => entry.key.isOdd)
                  .map((entry) => _buildCategoriaCard(entry.value))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaCard(Categoria categoria) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: GestureDetector(
        onTap: () => _toggleSeleccion(categoria),
        child: Stack(
          children: [
            ClipRRect(
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
                    bottom: 12,
                    left: 12,
                    right: 12,
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
            if (categoria.seleccionada)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}