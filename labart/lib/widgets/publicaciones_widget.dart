import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:labart/common/models/publicacion_model.dart';
import 'package:labart/features/detalles_publicacion/publicacion_detalle_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class PublicacionesWidget extends StatefulWidget {
  final bool isDark;
  final List<Publicacion>? initialPublicaciones;

  const PublicacionesWidget({
    super.key,
    required this.isDark,
    this.initialPublicaciones,
  });

  @override
  State<PublicacionesWidget> createState() => _PublicacionesWidgetState();
}

class _PublicacionesWidgetState extends State<PublicacionesWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Listas de publicaciones
  List<Publicacion> _todasLasPublicaciones = [];
  List<Publicacion> _publicacionesMostradas = [];
  
  // Estados de carga
  bool isLoading = true;
  bool _isLoadingMore = false;
  bool _hasError = false;
  bool _forceShowContent = false;
  String? errorMessage;
  
  // Control de scroll y paginación
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _perPage = 16;
  bool _hasMore = true;
  
  // Precarga de imágenes
  final Set<String> _preloadedImages = {};
  int _loadedImages = 0;

  @override
  void initState() {
    super.initState();
    
    if (widget.initialPublicaciones != null && widget.initialPublicaciones!.isNotEmpty) {
      _todasLasPublicaciones = widget.initialPublicaciones!;
      _cargarPrimeraPagina();
      isLoading = false;
    } else {
      _fetchTodasLasPublicaciones();
    }
    
    _scrollController.addListener(_scrollListener);
    
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_allImagesLoaded) {
        setState(() => _forceShowContent = true);
      }
    });
  }

  bool get _allImagesLoaded => _publicacionesMostradas.isEmpty || 
      _loadedImages >= _publicacionesMostradas.length;

  Future<void> _fetchTodasLasPublicaciones() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      _hasError = false;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final uri = Uri.parse('${THttpHelper.baseUrl}/publicacion');

      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      }).timeout(const Duration(seconds: 15));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _todasLasPublicaciones = data.map((json) => Publicacion.fromJson(json)).toList();
          _cargarPrimeraPagina();
          isLoading = false;
        });
        
        _preloadInitialImages();
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        _hasError = true;
        errorMessage = "Error al cargar publicaciones";
      });
    }
  }

  void _cargarPrimeraPagina() {
    final endIndex = _perPage < _todasLasPublicaciones.length 
        ? _perPage 
        : _todasLasPublicaciones.length;
    
    setState(() {
      _publicacionesMostradas = _todasLasPublicaciones.sublist(0, endIndex);
      _currentPage = 1;
      _hasMore = endIndex < _todasLasPublicaciones.length;
    });
  }

  Future<void> _cargarSiguientePagina() async {
    if (!_hasMore || _isLoadingMore) return;
    
    setState(() => _isLoadingMore = true);
    
    final startIndex = _currentPage * _perPage;
    if (startIndex >= _todasLasPublicaciones.length) {
      setState(() {
        _hasMore = false;
        _isLoadingMore = false;
      });
      return;
    }

    final endIndex = (startIndex + _perPage) < _todasLasPublicaciones.length
        ? startIndex + _perPage
        : _todasLasPublicaciones.length;

    await _preloadImagesForPage(startIndex, endIndex);

    if (!mounted) return;
    
    setState(() {
      _publicacionesMostradas.addAll(
        _todasLasPublicaciones.sublist(startIndex, endIndex)
      );
      _currentPage++;
      _hasMore = endIndex < _todasLasPublicaciones.length;
      _isLoadingMore = false;
    });
  }

  Future<void> _preloadImagesForPage(int start, int end) async {
    final futures = <Future>[];
    for (int i = start; i < end && i < _todasLasPublicaciones.length; i++) {
      futures.add(_preloadImage(_todasLasPublicaciones[i].imagenUrl));
    }
    await Future.wait(futures);
  }

  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = maxScroll * 0.99;

    if (currentScroll >= threshold && _hasMore && !_isLoadingMore) {
      _cargarSiguientePagina();
    }
  }

  void _preloadInitialImages() {
    for (int i = 0; i < 4 && i < _publicacionesMostradas.length; i++) {
      _preloadImage(_publicacionesMostradas[i].imagenUrl);
    }
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

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoading) {
      return _buildShimmer();
    }

    if (_hasError) {
      return Center(child: Text(errorMessage ?? 'Error al cargar publicaciones'));
    }

    if (_publicacionesMostradas.isEmpty) {
      return const Center(child: Text('No hay publicaciones disponibles'));
    }

    return Stack(
      children: [
        _buildPublicaciones(),
        if (_isLoadingMore) _buildBottomLoader(),
        if (!_allImagesLoaded && !_forceShowContent)
          Positioned.fill(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: _buildShimmer(),
            ),
          ),
      ],
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShimmerColumn(),
                  const SizedBox(width: 3.0),
                  _buildShimmerColumn(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerColumn() {
    return Expanded(
      child: Column(
        children: List.generate(
          8,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 4.0),
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPublicaciones() {
    final publicacionesIzquierda = <Publicacion>[];
    final publicacionesDerecha = <Publicacion>[];

    for (int i = 0; i < _publicacionesMostradas.length; i++) {
      if (i % 2 == 0) {
        publicacionesIzquierda.add(_publicacionesMostradas[i]);
      } else {
        publicacionesDerecha.add(_publicacionesMostradas[i]);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageColumn(publicacionesIzquierda),
                      const SizedBox(width: 3.0),
                      _buildImageColumn(publicacionesDerecha),
                    ],
                  ),
                  if (!_hasMore) 
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0), // Reducido el espacio
                      child: const Center(
                        child: Text(
                          'No hay más publicaciones',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageColumn(List<Publicacion> publicaciones) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: publicaciones.map((publicacion) {
          return GestureDetector(
            onTap: () {
              NavigationController.to.openDetail(
                publicacion,
                widget.isDark,
                _publicacionesMostradas,
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: publicacion.imagenUrl,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: widget.isDark 
                        ? Colors.grey[800]! : Colors.grey[200]!,
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: widget.isDark ? Colors.grey[800] : Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomLoader() {
    return Positioned(
      bottom: 8,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: widget.isDark ? const Color.fromARGB(255, 28, 34, 36) : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),

            boxShadow: [
              BoxShadow(
                color: widget.isDark ? Colors.white.withOpacity(0.2) : Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center( // Esto centra el loader dentro del contenedor
            child: SpinKitChasingDots(
              size: 35.0,
              color:TColors.primary ,
              duration: Duration(milliseconds: 1000),
            ),
          ),
        ),

      ),
    );
  }
}



class PublicacionDetalleWrapper extends StatefulWidget {
  final Publicacion publicacion;
  final bool isDark;

  const PublicacionDetalleWrapper({
    super.key,
    required this.publicacion,
    required this.isDark,
  });

  @override
  State<PublicacionDetalleWrapper> createState() => _PublicacionDetalleWrapperState();
}

class _PublicacionDetalleWrapperState extends State<PublicacionDetalleWrapper> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationController.to.popPage();
        return false;
      },
      child: PublicacionDetalleWidget(
        publicacion: widget.publicacion,
        isDark: widget.isDark,
      ),
    );
  }
}