
import 'package:flutter/material.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/constants/text_strings.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/navigation_bar.dart'; // Asegúrate de importar el NavigationController
import 'package:labart/common/models/publicacion_model.dart'; // Para el modelo Publicacion

class ExploreMoreWidget extends StatefulWidget {
  final bool isDark;
  final int currentPostId;

  const ExploreMoreWidget({
    super.key,
    required this.isDark,
    required this.currentPostId,
  });

  @override
  State<ExploreMoreWidget> createState() => _ExploreMoreWidgetState();
}

class _ExploreMoreWidgetState extends State<ExploreMoreWidget> {
  List<Publicacion> publicaciones = []; // Cambiado a tipo Publicacion
  bool isLoading = true;
  String? error;
  int? _lastLoadedPostId; // Track del último ID cargado

  @override
  void didUpdateWidget(covariant ExploreMoreWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentPostId != oldWidget.currentPostId && 
        widget.currentPostId != _lastLoadedPostId) {
      _loadRecomendaciones();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRecomendaciones();
  }

  Future<void> _loadRecomendaciones() async {
    if (widget.currentPostId == _lastLoadedPostId) return;
    
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final data = await THttpHelper.get('recomendaciones/publicacion/${widget.currentPostId}');
      
      if (mounted) {
        setState(() {
          publicaciones = (data['recomendaciones'] as List)
              .map((p) => Publicacion.fromJson(p))
              .toList();
          _lastLoadedPostId = widget.currentPostId;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = 'Error al cargar recomendaciones';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.xs,
        vertical: TSizes.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TTexts.masParaExplorar,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: TSizes.md),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (error != null)
            Text(error!, style: const TextStyle(color: Colors.red))
          else if (publicaciones.isEmpty)
            const Text('No hay recomendaciones disponibles.')
          else
            _buildTwoColumnGrid(),
        ],
      ),
    );
  }

  Widget _buildTwoColumnGrid() {
    final leftColumn = <Widget>[];
    final rightColumn = <Widget>[];

    for (int i = 0; i < publicaciones.length; i++) {
      final post = publicaciones[i];
      final imageCard = _buildImageCard(post);

      if (i.isEven) {
        leftColumn.add(imageCard);
      } else {
        rightColumn.add(imageCard);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: leftColumn)),
        const SizedBox(width: TSizes.xs),
        Expanded(child: Column(children: rightColumn)),
      ],
    );
  }

  Widget _buildImageCard(Publicacion publicacion) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.xs),
      child: GestureDetector(
        onTap: () {
          // Verificamos que la publicación tenga un ID válido
          if (publicacion.id > 0) {
            NavigationController.to.openDetail(
              publicacion,
              widget.isDark,
              publicaciones,
            );
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(TSizes.borderRadiusMd),
          child: Hero(
            tag: publicacion.imagenUrl,
            child: Image.network(
              publicacion.imagenUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => 
                _buildErrorPlaceholder(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Icon(Icons.error),
    );
  }

}