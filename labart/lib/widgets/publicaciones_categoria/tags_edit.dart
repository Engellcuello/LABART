import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class TagsEditorPage extends StatefulWidget {
  final List<String> selectedTags;

  const TagsEditorPage({Key? key, required this.selectedTags}) : super(key: key);

  @override
  _TagsEditorPageState createState() => _TagsEditorPageState();
}

class _TagsEditorPageState extends State<TagsEditorPage> {
  late List<String> _selectedTags;
  final TextEditingController _searchController = TextEditingController();
  bool _showHelperText = true;
  final FocusNode _searchFocusNode = FocusNode();
  final translator = GoogleTranslator();

  // Mapa para almacenar las traducciones
  final Map<String, String> _translations = {};
  
  // Lista de todas las etiquetas disponibles
  List<String> _allTags = [];

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
    _fetchTags(); // Llamar a la función para obtener las etiquetas al iniciar
    
    // Traducir las etiquetas seleccionadas inicialmente
    if (_selectedTags.isNotEmpty) {
      _translateTags(_selectedTags);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchTags() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final uri = Uri.parse('${THttpHelper.baseUrl}/etiquetas');

      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        
        // Verificar si la respuesta es una lista
        if (responseData is List) {
          setState(() {
            _allTags = responseData.cast<String>();
          });
          // Traducir las etiquetas obtenidas
          _translateTags(_allTags);
        } else {
          debugPrint('La respuesta no contiene una lista de etiquetas');
        }
      } else {
        debugPrint('Error al obtener etiquetas: ${response.statusCode}');
        debugPrint('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error al hacer la solicitud: $e');
    }
  }

  bool _matchesSearch(String tag, String searchText) {
    final originalMatch = tag.toLowerCase().contains(searchText.toLowerCase());
    final translatedMatch = _translations[tag]?.toLowerCase().contains(searchText.toLowerCase()) ?? false;
    return originalMatch || translatedMatch;
  }

  Future<String> _translateTag(String tag) async {
    if (_translations.containsKey(tag)) {
      return _translations[tag]!;
    }
    
    try {
      var translation = await translator.translate(tag, to: 'es');
      _translations[tag] = translation.text;
      return translation.text;
    } catch (e) {
      debugPrint('Error traduciendo $tag: $e');
      return tag;
    }
  }

  Future<void> _translateTags(List<String> tags) async {
    for (String tag in tags) {
      if (!_translations.containsKey(tag)) {
        await _translateTag(tag);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  void _onSearchChanged() {
    setState(() {
      _showHelperText = _searchController.text.isEmpty && _selectedTags.isEmpty;
    });
  }

  void _onFocusChanged() {
    setState(() {});
  }

  List<String> get _filteredTags {
    if (_searchController.text.isEmpty) {
      return [];
    }
    final searchText = _searchController.text.toLowerCase();
    return _allTags
        .where((tag) => 
            _matchesSearch(tag, searchText) &&
            !_selectedTags.contains(tag))
        .toList();
  }

  void _toggleTag(String tag) async {
    if (!_translations.containsKey(tag)) {
      await _translateTag(tag);
    }
    
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
      _showHelperText = _searchController.text.isEmpty && _selectedTags.isEmpty;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: dark? Colors.white : Colors.black,),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Etiquetas'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onPressed: _selectedTags.isNotEmpty
                  ? () => Navigator.pop(context, _selectedTags)
                  : null,
              child: Container(
                height: 35,
                width: 60,
                decoration: BoxDecoration(
                  gradient: _selectedTags.isNotEmpty
                      ? LinearGradient(
                          colors: [
                            Color.fromARGB(157, 100, 180, 246),
                            Color.fromARGB(255, 219, 77, 255),
                            Color.fromARGB(159, 211, 170, 212),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: dark? _selectedTags.isEmpty
                      ? const Color.fromARGB(255, 30, 36, 37)
                      : null 
                      :_selectedTags.isEmpty
                          ? const Color.fromARGB(167, 207, 207, 200)
                          : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Listo',
                  style: TextStyle(
                    color: _selectedTags.isEmpty
                        ? const Color.fromARGB(255, 167, 167, 167)
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Buscar etiquetas',
                prefixIcon: _searchFocusNode.hasFocus || _searchController.text.isNotEmpty
                    ? null
                    : const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: _clearSearch,
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Helper text
            if (_showHelperText)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Elige etiquetas relacionadas para llegar a personas interesadas en publicaciones como la tuya. '
                  'Esto no se mostrará en tu publicación.',
                  style: TextStyle(color: dark ? const Color.fromARGB(216, 255, 255, 255) : Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.start,
                ),
              ),
            
            // Selected tags section
            if (_selectedTags.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Seleccionados',
                    style: TextStyle(
                      color: Color.fromARGB(255, 122, 122, 122),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedTags.length,
                  itemBuilder: (context, index) {
                    final tag = _selectedTags[index];
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: ActionChip(
                        label: FutureBuilder<String>(
                          future: _translateTag(tag),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? tag,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9), 
                                fontWeight: FontWeight.w600, 
                              ),
                            );
                          },
                        ),
                        onPressed: () => _toggleTag(tag),
                        backgroundColor: TColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.transparent, width: 0),
                        ),
                        elevation: 0,
                        pressElevation: 0,
                        visualDensity: VisualDensity.compact,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        disabledColor: Colors.transparent,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Filtered tags (only shown when searching)
            if (_searchController.text.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 1,
                    runSpacing: 1,
                    children: _filteredTags.map((tag) {
                      return Material(
                        color: Colors.transparent,
                        child: ActionChip(
                          label: FutureBuilder<String>(
                            future: _translateTag(tag),
                            builder: (context, snapshot) {
                              return Text(
                                snapshot.data ?? tag,
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.9), 
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                          onPressed: () => _toggleTag(tag),
                          backgroundColor: dark? const Color.fromARGB(255, 88, 94, 95) : const Color.fromARGB(255, 233, 233, 226),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.transparent, width: 0),
                          ),
                          elevation: 0,
                          pressElevation: 0,
                          visualDensity: VisualDensity.compact,
                          shadowColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          disabledColor: Colors.transparent,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}