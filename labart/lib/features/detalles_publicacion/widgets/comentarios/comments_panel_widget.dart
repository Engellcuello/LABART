import 'package:flutter/material.dart';
import 'package:labart/common/models/publicacion_model.dart';
import 'package:labart/features/detalles_publicacion/widgets/comentarios/ComentarioService.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/constants/text_strings.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsPanelWidget extends StatefulWidget {
  final bool isDark;
  final VoidCallback onClose;
  final Animation<Offset> animation;
  final List<ComentarioConUsuario> comentarios;
  final int publicacionId;
  final Function() onComentarioAgregado;
  final Function() onComentarioEliminado;

  const CommentsPanelWidget({
    super.key,
    required this.isDark,
    required this.onClose,
    required this.animation,
    required this.comentarios,
    required this.publicacionId,
    required this.onComentarioAgregado,
    required this.onComentarioEliminado,
  });

  @override
  State<CommentsPanelWidget> createState() => _CommentsPanelWidgetState();
}

class _CommentsPanelWidgetState extends State<CommentsPanelWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _commentController = TextEditingController();
  final ComentarioService _comentarioService = ComentarioService(baseUrl: THttpHelper.baseUrl);
  int? _idUsuario;

  @override
  void initState() {
    super.initState();
    _obtenerIdUsuario();
  }

  Future<void> _obtenerIdUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUsuario = prefs.getInt('id_usuario');
    });
  }

  void _mostrarMenuEliminar(Comentario comentario) {
    final dark = THelperFunctions.isDarkMode(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      showDragHandle: false, // 👈 Esto quita la línea externa
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: dark ? TColors.blakfondo : TColors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 👇 Línea decorativa manual dentro de la carta
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: TSizes.md),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Eliminar comentario',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _eliminarComentario(comentario.ID_comentario);
              },
            ),
            const SizedBox(height: TSizes.sm),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _enviarComentario() async {
    if (_commentController.text.trim().isEmpty) return;
    if (_idUsuario == null) return;

    try {
      await _comentarioService.crearComentario(
        contenido: _commentController.text.trim(),
        usuarioId: _idUsuario!,
        publicacionId: widget.publicacionId,
      );
      
      _commentController.clear();
      FocusScope.of(context).unfocus();
      widget.onComentarioAgregado();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar comentario: ${e.toString()}')),
      );
    }
  }

  Future<void> _eliminarComentario(int comentarioId) async {
    try {
      await _comentarioService.eliminarComentario(comentarioId);
      widget.onComentarioEliminado();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentario eliminado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar comentario: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return SlideTransition(
      position: widget.animation,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: dark ? TColors.black : TColors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(TSizes.borderRadiusXl),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            // Barra de arrastre
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! > 5) {
                  widget.onClose();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: TSizes.sm, bottom: TSizes.sm),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: dark ? TColors.darkGrey : TColors.grey,
                      borderRadius: BorderRadius.circular(TSizes.borderRadiusSm),
                    ),
                  ),
                ),
              ),
            ),

            // Título
            Padding(
              padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
              child: Text(
                TTexts.comentarios,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: dark ? TColors.white : TColors.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

            // Lista de comentarios
            Expanded(
              child: widget.comentarios.isEmpty
                  ? Center(
                      child: Text(
                        'No hay comentarios aún',
                        style: TextStyle(
                          color: dark ? TColors.lightGrey : TColors.darkGrey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: TSizes.sm),
                      itemCount: widget.comentarios.length,
                      itemBuilder: (context, index) {
                        final comentario = widget.comentarios[index];
                        final esPropietario = comentario.comentario.ID_usuario == _idUsuario;
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.md,
                            vertical: TSizes.xs,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dark ? TColors.darkGrey : TColors.lightGrey,
                                ),
                                child: comentario.usuario.imgUsuario.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        color: dark ? TColors.white : TColors.black,
                                        size: 24,
                                      )
                                    : ClipOval(
                                        child: Image.network(
                                          comentario.usuario.imgUsuario,
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(
                                              Icons.person,
                                              color: dark ? TColors.white : TColors.black,
                                              size: 24,
                                            );
                                          },
                                        ),
                                      ),
                              ),
                              const SizedBox(width: TSizes.sm),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Fila superior con nombre, fecha y opciones
                                    SizedBox(
                                      height: 24, // Altura fija para mantener alineación
                                      child: Row(
                                        children: [
                                          Text(
                                            comentario.usuario.nombre,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: dark ? TColors.white : TColors.black,
                                                ),
                                          ),
                                          const SizedBox(width: TSizes.sm),
                                          Text(
                                            _formatPostTime(comentario.comentario.Fecha_comentario),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: dark ? TColors.lightGrey : TColors.darkGrey,
                                                ),
                                          ),
                                          const Spacer(),
                                          if (esPropietario)
                                            Transform.translate(
                                              offset: const Offset(0, 10), // Ajuste fino de posición
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                constraints: const BoxConstraints(),
                                                icon: Icon(Icons.more_vert, size: 20),
                                                onPressed: () => _mostrarMenuEliminar(comentario.comentario),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    // Contenido del comentario
                                    Padding(
                                      padding: const EdgeInsets.only(right: 24), // Espacio para los 3 puntos
                                      child: Text(
                                        comentario.comentario.Contenido_comentario,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: dark ? TColors.lightGrey : TColors.black,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: TSizes.sm),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),

            // Input para nuevo comentario
            _buildCommentInput(dark),
          ],
        ),
      ),
    );
  }

  String _formatPostTime(DateTime postDate) {
    final now = DateTime.now();
    final difference = now.difference(postDate);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Hace $years ${years == 1 ? 'año' : 'años'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months ${months == 1 ? 'mes' : 'meses'}';
    } else if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'}';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'Ahora mismo';
    }
  }

  Widget _buildCommentInput(bool dark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.sm,
      ),
      decoration: BoxDecoration(
        color: dark ? TColors.darkerGrey : TColors.lightContainer,
        border: Border(
          top: BorderSide(
            color: dark ? TColors.darkGrey : TColors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _commentController,
              style: TextStyle(
                color: dark ? TColors.white : TColors.black,
              ),
              decoration: InputDecoration(
                hintText: TTexts.agregarComentario,
                hintStyle: TextStyle(
                  color: dark ? TColors.lightGrey : TColors.darkGrey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: dark ? TColors.darkGrey.withOpacity(0.5) : TColors.light,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: TSizes.md,
                  vertical: TSizes.sm,
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
          const SizedBox(width: TSizes.sm),
          IconButton(
            icon: Icon(Icons.send, 
                color: dark ? TColors.primary : TColors.darkGrey),
            onPressed: _enviarComentario,
          ),
        ],
      ),
    );
  }
}