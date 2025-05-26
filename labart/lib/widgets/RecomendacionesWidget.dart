import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labart/common/models/publicacion_model.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';


class RecomendacionesWidget extends StatefulWidget {
  final bool isDark;

  const RecomendacionesWidget({super.key, required this.isDark});

  @override
  State<RecomendacionesWidget> createState() => _RecomendacionesWidgetState();
}

class _RecomendacionesWidgetState extends State<RecomendacionesWidget> 
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Recomendacion> recomendaciones = [];
  bool isLoading = true;
  String? errorMessage;
  final ScrollController _scrollController = ScrollController();
  final Set<String> _preloadedImages = {};

  @override
  void initState() {
    super.initState();
    _fetchRecomendaciones();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    // Puedes implementar scroll infinito aquí si es necesario
  }

  Future<void> _preloadImage(String url) async {
    if (_preloadedImages.contains(url)) return;
    
    try {
      final provider = CachedNetworkImageProvider(url);
      await precacheImage(provider, context);
      _preloadedImages.add(url);
    } catch (e) {
      debugPrint('Error precargando imagen: $e');
    }
  }

  Future<void> _fetchRecomendaciones() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final userId = prefs.getInt('id_usuario') ?? 0;

      final response = await http.get(
        Uri.parse('${THttpHelper.baseUrl}/recomendacioneshome/$userId'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      
      if (!mounted) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          setState(() {
            recomendaciones = (data['recomendaciones'] as List)
                .map((json) => Recomendacion.fromJson(json))
                .toList();
            isLoading = false;
          });
          
          // Precargar primeras imágenes
          for (int i = 0; i < 4 && i < recomendaciones.length; i++) {
            _preloadImage(recomendaciones[i].imagenUrl);
          }
        } else {
          setState(() {
            errorMessage = "No se pudieron obtener recomendaciones";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Error al cargar recomendaciones: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.isDark ? Colors.blueAccent : Colors.deepPurple,
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    if (recomendaciones.isEmpty) {
      return const Center(child: Text("No hay recomendaciones disponibles"));
    }

    return _buildRecomendaciones();
  }

  Widget _buildRecomendaciones() {
    double paddingTotal = 3.0;
    double paddingSide = paddingTotal / 2;

    final recomendacionesIzquierda = <Recomendacion>[];
    final recomendacionesDerecha = <Recomendacion>[];

    for (int i = 0; i < recomendaciones.length; i++) {
      if ((i % 2) == 0) {
        recomendacionesIzquierda.add(recomendaciones[i]);
      } else {
        recomendacionesDerecha.add(recomendaciones[i]);
      }
    }

    return Padding(
      padding: EdgeInsets.all(paddingTotal),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageColumn(recomendacionesIzquierda, paddingSide, 'izquierda'),
                _buildImageColumn(recomendacionesDerecha, paddingSide, 'derecha'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageColumn(List<Recomendacion> recomendaciones, double padding, String tag) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: tag == 'derecha' ? padding : 0,
          right: tag == 'izquierda' ? padding : 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: recomendaciones.map((recomendacion) {
            return GestureDetector(
              onTap: () {
                if (!_preloadedImages.contains(recomendacion.imagenUrl)) {
                  _preloadImage(recomendacion.imagenUrl);
                }
                
                // Convertir Recomendacion a Publicacion para usar el mismo detalle
                final publicacion = Publicacion(
                  id: recomendacion.idPublicacion,
                  titulo: recomendacion.titulo,
                  esExplicita: recomendacion.esExplicita,
                  descripcion: recomendacion.descripcion,
                  imagenUrl: recomendacion.imagenUrl,
                  fecha: recomendacion.fechaPublicacion,
                  usuarioId: recomendacion.usuarioId,
                  // Agrega otros campos necesarios para PublicacionDetalleWidget
                );
                
                NavigationController.to.openDetail(
                  publicacion,
                  widget.isDark,
                  [], // Pasa lista vacía o las recomendaciones convertidas a Publicacion
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Hero(
                    tag: recomendacion.imagenUrl,
                    child: CachedNetworkImage(
                      imageUrl: recomendacion.imagenUrl,
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      memCacheHeight: 600,
                      fadeInDuration: Duration.zero,
                      placeholder: (context, url) => Container(
                        height: 200,
                        color: widget.isDark ? Colors.grey[800] : Colors.grey[200],
                        child: _preloadedImages.contains(url)
                            ? null
                            : Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    widget.isDark ? Colors.blueAccent : Colors.deepPurple,
                                  ),
                                ),
                              ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 200,
                        color: widget.isDark ? Colors.grey[800] : Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.error,
                            color: widget.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}