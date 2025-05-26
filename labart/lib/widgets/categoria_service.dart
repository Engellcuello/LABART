import 'package:http/http.dart' as http;
import 'package:labart/utils/http/http_client.dart';
import 'dart:convert';

import 'package:labart/widgets/categoria_model.dart';



class CategoriaService {
  static Future<List<Categoria>> fetchCategorias() async {
    final response = await http.get(Uri.parse('${THttpHelper.baseUrl}/categoria'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => Categoria.fromJson(e)).toList();
    } else {
      throw Exception('Fallo la carga de categorías');
    }
  }

  static List<Categoria> filtrarCategorias(List<Categoria> categorias, String query) {
    if (query.isEmpty) return categorias;
    return categorias.where((categoria) => 
      categoria.nombre.toLowerCase().contains(query.toLowerCase()) ||
      categoria.descripcion.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}