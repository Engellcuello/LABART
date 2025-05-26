import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:labart/widgets/navigation_bar.dart'; // Importa el NavigationController
import 'package:labart/common/models/publicacion_model.dart'; // Importa el modelo Publicacion

class UserProfilePosts extends StatefulWidget {
  final int userId;
  final String tabType;
  final bool isDark;

  const UserProfilePosts({
    super.key,
    required this.userId,
    required this.tabType,
    required this.isDark,
  });

  @override
  State<UserProfilePosts> createState() => _UserProfilePostsState();
}

class _UserProfilePostsState extends State<UserProfilePosts> 
    with AutomaticKeepAliveClientMixin<UserProfilePosts> {
  // Caché estático con tiempo de expiración
  static final Map<String, CacheEntry> _cache = {};
  static Timer? _cacheCleanupTimer;
  
  List<dynamic> _posts = [];
  bool _isLoading = true;
  bool _hasError = false;
  int _loadedImages = 0;
  bool _forceShowContent = false;
  bool _initialFetchDone = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initCacheCleanup();
    _fetchPublicaciones();
    
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_allImagesLoaded) {
        setState(() => _forceShowContent = true);
      }
    });
  }

  // Inicializa el timer para limpiar la caché periódicamente
  void _initCacheCleanup() {
    _cacheCleanupTimer?.cancel();
    _cacheCleanupTimer = Timer.periodic(const Duration(minutes: 15), (timer) {
      final now = DateTime.now();
      _cache.removeWhere((key, entry) => now.difference(entry.timestamp) > const Duration(minutes: 15));
    });
  }

  @override
  void dispose() {
    _cacheCleanupTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(UserProfilePosts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId || oldWidget.tabType != widget.tabType) {
      _fetchPublicaciones();
    }
  }

  Future<void> _fetchPublicaciones() async {
    // Clave de caché que incluye userId y tabType
    final cacheKey = '${widget.userId}_${widget.tabType}';

    // Verificar si hay una entrada válida en caché
    if (_cache.containsKey(cacheKey)) {
      final entry = _cache[cacheKey]!;
      final now = DateTime.now();
      
      // Si la entrada es reciente (menos de 15 minutos)
      if (now.difference(entry.timestamp) < const Duration(minutes: 15)) {
        if (mounted) {
          setState(() {
            _posts = entry.data;
            _isLoading = false;
            _initialFetchDone = true;
          });
        }
        return;
      } else {
        // Eliminar entrada expirada
        _cache.remove(cacheKey);
      }
    }

    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _hasError = false;
        });
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      
      final uri = Uri.parse('${THttpHelper.baseUrl}/publicaciones_guardadas/${widget.userId}');
      
      final response = await http.get(uri, headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final publicaciones = widget.tabType == 'creadas'
            ? data['publicaciones'] ?? data['publicaciones_creadas'] ?? []
            : data['publicaciones'] ?? data['publicaciones_guardadas'] ?? [];

        // Guardar en caché con marca de tiempo
        _cache[cacheKey] = CacheEntry(publicaciones, DateTime.now());

        if (mounted) {
          setState(() {
            _posts = publicaciones;
            _isLoading = false;
            _loadedImages = 0;
            _initialFetchDone = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  void _onImageLoaded() {
    if (!mounted) return;
    setState(() => _loadedImages++);
  }

  bool get _allImagesLoaded => _posts.isEmpty || _loadedImages >= _posts.length;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    if (_hasError) {
      return const Center(child: Text('Error al cargar las publicaciones'));
    }

    if (_isLoading && !_initialFetchDone) {
      return _buildShimmer();
    }

    if (_posts.isEmpty) {
      return const Center(child: Text('No hay publicaciones para mostrar'));
    }

    return Stack(
      children: [
        Opacity(
          opacity: _allImagesLoaded || _forceShowContent ? 1.0 : 0.5,
          child: _buildPostGrid(),
        ),
        
        if (!_allImagesLoaded && !_forceShowContent)
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.7),
              child: _buildShimmer(),
            ),
          ),
      ],
    );
  }

  Widget _buildPostGrid() {
  final leftColumn = <Widget>[];
  final rightColumn = <Widget>[];

  for (int i = 0; i < _posts.length; i++) {
    final postData = _posts[i];
    final imageCard = _PostCard(
      imageUrl: postData['Img_publicacion'],
      onImageLoaded: _onImageLoaded,
      onTap: () => _navigateToPostDetail(postData),
    );
    if (i.isEven) {
      leftColumn.add(imageCard);
    } else {
      rightColumn.add(imageCard);
    }
  }

  return NotificationListener<ScrollNotification>(
    onNotification: (notification) {
      // Permitir que las notificaciones de scroll se propaguen
      return false;
    },
    child: SingleChildScrollView(
      key: PageStorageKey<String>(widget.tabType),
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(TSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: leftColumn,
            ),
          ),
          const SizedBox(width: TSizes.xs),
          Expanded(
            child: Column(
              children: rightColumn,
            ),
          ),
        ],
      ),
    ),
  );
}

  void _navigateToPostDetail(Map<String, dynamic> postData) {
    debugPrint('Iniciando navegación a detalle...');
    try {
      debugPrint('Datos de la publicación: $postData');
      final publicacion = Publicacion.fromJson(postData);
      debugPrint('Publicación convertida: ID ${publicacion.id}');
      
      if (publicacion.id > 0) {
        final publicaciones = _posts.map((p) => Publicacion.fromJson(p)).toList();
        debugPrint('Número de publicaciones: ${publicaciones.length}');
        
        debugPrint('Llamando a NavigationController.to.openDetail...');
        NavigationController.to.openDetail(
          publicacion,
          widget.isDark,
          publicaciones,
        );
        debugPrint('Navegación completada');
      } else {
        debugPrint('ID de publicación inválido');
      }
    } catch (e, stack) {
      debugPrint('Error al navegar: $e');
      debugPrint(stack.toString());
    }
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.xs),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: List.generate(5, (index) => Container(
                  margin: const EdgeInsets.only(bottom: TSizes.xs),
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  ),
                )),
              ),
            ),
            const SizedBox(width: TSizes.xs),
            Expanded(
              child: Column(
                children: List.generate(5, (index) => Container(
                  margin: const EdgeInsets.only(bottom: TSizes.xs),
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onImageLoaded;
  final VoidCallback onTap;

  const _PostCard({
    required this.imageUrl,
    required this.onImageLoaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: TSizes.xs),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
          child: Hero(
            tag: imageUrl, // Añade Hero con tag único
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => onImageLoaded());
                  return child;
                }
                return Container(
                  height: 150,
                  color: Colors.grey[200],
                );
              },
              errorBuilder: (context, error, stackTrace) {
                WidgetsBinding.instance.addPostFrameCallback((_) => onImageLoaded());
                return Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CacheEntry {
  final List<dynamic> data;
  final DateTime timestamp;

  CacheEntry(this.data, this.timestamp);
}

void clearProfilePostsCache() {
  _UserProfilePostsState._cache.clear();
  _UserProfilePostsState._cacheCleanupTimer?.cancel();
}