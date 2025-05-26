import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/features/detalles_publicacion/widgets/comentarios/ComentarioService.dart';
import 'package:labart/features/detalles_publicacion/widgets/comentarios/comments_panel_widget.dart';
import 'package:labart/features/detalles_publicacion/widgets/creador/post_header_widget.dart';
import 'package:labart/features/detalles_publicacion/widgets/explorar/explore_more_widget.dart';
import 'package:labart/features/detalles_publicacion/widgets/mas_opciones/options_panel_widget.dart';
import 'package:labart/features/detalles_publicacion/widgets/titulo_descripcion/post_content_widget.dart';
import 'package:labart/features/detalles_publicacion/widgets/zoom/image_zoom_widget.dart';
import 'package:labart/features/detalles_publicacion/widgets_propios/publicacion_guardada_service.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/image_strings.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/common/models/publicacion_model.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class PublicacionDetalleWidget extends StatefulWidget {
  final Publicacion publicacion;
  final bool isDark;

  const PublicacionDetalleWidget({
    super.key,
    required this.publicacion,
    required this.isDark,
  });

  @override
  State<PublicacionDetalleWidget> createState() => _PublicacionDetalleWidgetState();
}

class _PublicacionDetalleWidgetState extends State<PublicacionDetalleWidget> 
  with TickerProviderStateMixin {
  bool _isDisposed = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool _showComments = false;
  bool _showOptions = false;
  bool _showImageZoom = false;
  final _imageKey = GlobalKey();
  bool _historialEnviado = false;
  bool _isGuardado = false;
  bool _esPropietario = false;
  late PublicacionGuardadaService _guardadaService;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isLoadingUser = false;
  String? _userError;
  final ScrollController _scrollController = ScrollController();

  // Variables para reacciones
  int? _userReactionId; // 2=like, 3=love, 4=wow, 5=dislike
  Map<int, int> _reactionCounts = {
    1: 0, // like
    2: 0, // love
    3: 0, // wow
    4: 0  // dislike
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    );
    

    _loadInitialData();
    _insertHistorialAsync();
    _verificarPropietarioYGuardado();
    _loadReactions();
  }

  Future<void> _verificarPropietarioYGuardado() async {
    final prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('id_usuario') ?? 0;
    
    _esPropietario = idUsuario == widget.publicacion.usuarioId;
    
    if (!_esPropietario) {
      _guardadaService = await PublicacionGuardadaService.crear(
        widget.publicacion.id,
        baseUrl: THttpHelper.baseUrl,
      );
      _isGuardado = await _guardadaService.verificarSiEstaGuardada();
      if (mounted) setState(() {});
    }
  }

  Future<void> _toggleGuardar() async {
    try {
      await _scaleController.forward(from: 0.0);
      
      if (mounted) {
        setState(() {
          _isGuardado = !_isGuardado;
        });
      }
      
      bool exito;
      if (_isGuardado) {
        exito = await _guardadaService.guardarPublicacion();
      } else {
        exito = await _guardadaService.eliminarPublicacionGuardada();
      }

      await _scaleController.reverse(from: 1.0);
      
      if (!exito && mounted) {
        setState(() {
          _isGuardado = !_isGuardado;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar el estado de guardado')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isGuardado = !_isGuardado;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      _scaleController.reverse(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(covariant PublicacionDetalleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.publicacion.id != oldWidget.publicacion.id) {
      _showComments = false;
      _showOptions = false;
      _historialEnviado = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(0.0);
        }
      });

      _resetState();
      _loadInitialData();
      _insertHistorialAsync();
      _loadReactions();
    }
  }

  void _resetState() {
    _showComments = false;
    _showOptions = false;
    _isLoadingUser = false;
    _userError = null;
    widget.publicacion.usuario = null;
    widget.publicacion.comentarios = null;
    _loadReactions();
    
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
  }

  Future<void> _loadInitialData() async {
    await _loadUserData();
    await _loadComentarios();
    await _loadReactions();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _loadReactions() async {
    final prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('id_usuario') ?? 0;
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('${THttpHelper.baseUrl}/publicacion_reaccion?publicacion=${widget.publicacion.id}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final reacciones = jsonDecode(response.body) as List;
        
        // Reiniciar contadores
        _reactionCounts = {1: 0, 2: 0, 3: 0, 4: 0};
        _userReactionId = null;
        
        for (var reaccion in reacciones) {
          final tipo = reaccion['ID_reaccion'] as int;
          _reactionCounts[tipo] = (_reactionCounts[tipo] ?? 0) + 1;
          
          if (reaccion['ID_usuario'] == idUsuario) {
            _userReactionId = tipo;
          }
        }
        
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint('Error al cargar reacciones: $e');
    }
  }

  Future<void> _loadUserData() async {
    widget.publicacion.usuario = null;

    if (_isDisposed) return; 
    
    setState(() {
      _isLoadingUser = true;
      _userError = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${THttpHelper.baseUrl}/usuario/${widget.publicacion.usuarioId}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 15));

      if (_isDisposed) return; 

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        
        if (!_isDisposed) {
          setState(() {
            widget.publicacion.usuario = Usuario.fromJson(userData);
          });
        }
      } else if (!_isDisposed) {
        setState(() {
          _userError = "No se pudo cargar la información del usuario";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _userError = "Error al cargar datos del usuario";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUser = false;
        });
      }
    }
  }

  Future<void> _insertHistorialAsync() async {
    if (_historialEnviado || _isDisposed) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final idUsuario = prefs.getInt('id_usuario') ?? 0;
      
      if (idUsuario == 0) return;

      final uri = Uri.parse('${THttpHelper.baseUrl}/historial');
      final client = http.Client();

      final response = await client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ID_usuario': idUsuario,
          'ID_publicacion': widget.publicacion.id,
        }),
      );

      if (!_isDisposed && (response.statusCode == 200 || response.statusCode == 201)) {
        setState(() {
          _historialEnviado = true;
        });
      }
    } catch (e) {
      debugPrint('Error al insertar historial: $e');
    }
  }

  Future<void> _actualizarComentarios() async {
    if (_isDisposed) return;
    
    try {
      // Mostrar indicador de carga si es necesario
      if (mounted) {
        setState(() {
          _isLoadingUser = true;
        });
      }

      // Usar tu método existente _loadComentarios que ya maneja todo el proceso
      await _loadComentarios();
      
      // Opcional: Mostrar feedback al usuario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comentarios actualizados'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error al actualizar comentarios: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar comentarios'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted && !_isDisposed) {
        setState(() {
          _isLoadingUser = false;
        });
      }
    }
  }

  Future<void> _loadComentarios() async {
    if (_isDisposed || !mounted) return;

    setState(() {
      widget.publicacion.comentarios = [];
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    
    try {
      final response = await http.get(
        Uri.parse('${THttpHelper.baseUrl}/comentario?publicacionId=${widget.publicacion.id}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(const Duration(seconds: 30));

      if (_isDisposed) return;

      if (response.statusCode == 200) {
        final List<dynamic> comentariosData = jsonDecode(response.body);
        final List<ComentarioConUsuario> comentariosConUsuarios = [];

        await Future.wait(comentariosData.map((comentarioJson) async {
          if (_isDisposed) return;
          final comentario = Comentario.fromJson(comentarioJson as Map<String, dynamic>);
          
          if (comentario.ID_publicacion == widget.publicacion.id) {
            try {
              final usuarioResponse = await http.get(
                Uri.parse('${THttpHelper.baseUrl}/usuario/${comentario.ID_usuario}'),
                headers: {
                  "Content-Type": "application/json",
                  "Authorization": "Bearer $token",
                },
              ).timeout(const Duration(seconds: 5));

              if (!_isDisposed && usuarioResponse.statusCode == 200) {
                final usuarioData = jsonDecode(usuarioResponse.body);
                final usuario = Usuario.fromJson(usuarioData);
                
                comentariosConUsuarios.add(ComentarioConUsuario(
                  comentario: comentario,
                  usuario: usuario,
                ));
              }
            } catch (e) {
              debugPrint("Error al cargar usuario para comentario: ${e.toString()}");
            }
          }
        }));

        comentariosConUsuarios.sort((a, b) => b.comentario.Fecha_comentario.compareTo(a.comentario.Fecha_comentario));

        setState(() {
          widget.publicacion.comentarios = comentariosConUsuarios;
        });
      }
    } catch (e) {
      debugPrint("Error al cargar comentarios: ${e.toString()}");
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _isDisposed = true; 
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _toggleComments() async {
    if (!_showComments) {
      await _loadComentarios();
    }
    setState(() {
      _showComments = !_showComments;
      _showOptions = false;
      if (_showComments) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _toggleOptions() {
    setState(() {
      _showOptions = !_showOptions;
      _showComments = false;
      if (_showOptions) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _toggleImageZoom() {
    setState(() {
      _showImageZoom = !_showImageZoom;
    });
  }

  @override
  Widget build(BuildContext context) {

    THelperFunctions.isDarkMode(context);
    return WillPopScope(
      onWillPop: () async {
        NavigationController.to.popPage();
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).padding.top.clamp(0, 0),
          ),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.publicacion.imagenUrl,
                    child: Material(
                      type: MaterialType.transparency,
                      child: GestureDetector(
                        onTap: _toggleImageZoom,
                        child: _buildPostImage(),
                      ),
                    ),
                  ),
                  _buildInteractionSection(),
                  if (_isLoadingUser)
                    const Padding(
                      padding: EdgeInsets.all(TSizes.md),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_userError != null)
                    Padding(
                      padding: const EdgeInsets.all(TSizes.md),
                      child: Text(
                        _userError!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  PostHeaderWidget(
                    isDark: widget.isDark,
                    publicacion: widget.publicacion,
                  ),
                  PostContentWidget(
                    isDark: widget.isDark,
                    publicacion: widget.publicacion,
                  ),
                  ExploreMoreWidget(isDark: widget.isDark, currentPostId: widget.publicacion.id),
                ],
              ),
            ),
            _buildBackButton(),
            if (_showComments || _showOptions) _buildPanelOverlay(),
            if (_showComments)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _animation,
                  child: CommentsPanelWidget(
                    isDark: widget.isDark,
                    onClose: _toggleComments,
                    animation: _animation,
                    comentarios: widget.publicacion.comentarios ?? [],
                    publicacionId: widget.publicacion.id,
                    onComentarioAgregado: _actualizarComentarios, // Necesitas implementar esta función
                    onComentarioEliminado: _actualizarComentarios, // Necesitas implementar esta función
                  ),
                ),
              ),
            if (_showOptions)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _animation,
                  child: OptionsPanelWidget(
                    isDark: widget.isDark,
                    onClose: _toggleOptions,
                    id_usuario_publicacion: widget.publicacion.usuarioId,
                    imageUrl: widget.publicacion.imagenUrl,
                    publicacion: widget.publicacion,
                  ),
                ),
              ),
            if (_showImageZoom)
              ImageZoomWidget(
                imageProvider: CachedNetworkImageProvider(widget.publicacion.imagenUrl),
                onClose: _toggleImageZoom,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostImage() {
    return Container(
      key: _imageKey,
      padding: const EdgeInsets.symmetric(horizontal: TSizes.xs),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CachedNetworkImage(
            imageUrl: widget.publicacion.imagenUrl,
            width: constraints.maxWidth,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildImagePlaceholder(constraints.maxWidth),
            errorWidget: (context, url, error) => _buildDynamicErrorPlaceholder(constraints.maxWidth),
            imageBuilder: (context, imageProvider) {
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TSizes.borderRadiusLg +10),
                  child: Image(
                    image: imageProvider,
                    width: constraints.maxWidth,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildImagePlaceholder(double width) {
    return Container(
      width: width,
      color: widget.isDark ? const Color.fromARGB(0, 33, 33, 33) : const Color.fromARGB(0, 238, 238, 238),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.isDark ? const Color.fromARGB(0, 64, 124, 255) : const Color.fromARGB(0, 77, 40, 40),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicErrorPlaceholder(double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: widget.isDark ? const Color.fromARGB(0, 66, 66, 66) : const Color.fromARGB(0, 224, 224, 224),
        borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
      ),
      child: Center(
        child: Icon(
          Icons.error,
          color: widget.isDark ? TColors.textWhite : TColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildInteractionSection() {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.sm,
      ),
      child: Row(
        children: [
          _buildCustomReactionButton(),
          const SizedBox(width: TSizes.lg),
          _buildCommentsButton(),
          const SizedBox(width: TSizes.lg),
          if (!_esPropietario)
            GestureDetector(
              onTap: _toggleGuardar,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 - (0.2 * _scaleAnimation.value),
                    child: Icon(
                      _isGuardado ? Icons.bookmark : Icons.bookmark_border,
                      size: 35,
                      color: _isGuardado ? const Color(0xFF64B4F6) : dark ? Colors.white : Colors.black,
                    ),
                  );
                },
              ),
            ),
          const Spacer(),
          IconButton(
            icon: Icon(Iconsax.more_copy, size: TSizes.iconLg),
            onPressed: _toggleOptions,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomReactionButton() {
    final isDark = THelperFunctions.isDarkMode(context);
    final hasReaction = _userReactionId != null;
    final currentReaction = _getReactionNameFromId(_userReactionId);
    
    // Cambio clave aquí: Mostrar solo el conteo de la reacción actual o likes si no hay
    final reactionCount = hasReaction 
        ? _reactionCounts[_userReactionId] ?? 0 
        : _reactionCounts[1] ?? 0; // 1 = like

    return GestureDetector(
      onTap: () async {
        if (hasReaction) {
          await _deleteReaction();
        } else {
          await _sendReactionToServer(1); // Like por defecto
        }
      },
      onLongPress: () => _showReactionsDialog(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildReactionIcon(
            hasReaction ? currentReaction! : 'like',
            size: 35,
            isSelected: hasReaction,
          ),
          const SizedBox(width: 4),
          Text(
            reactionCount.toString(), // Usamos el conteo específico en lugar del total
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: hasReaction 
                ? const Color.fromARGB(255, 62, 166, 252)
                : (isDark ? Colors.white : Colors.black),
            ),
          )
        ],
      ),
    );
  }
  Future<void> _showReactionsDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 130),
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDialogReaction('like', TImages.like, _reactionCounts[1] ?? 0),
                    const SizedBox(width: 15),
                    _buildDialogReaction('love', TImages.love, _reactionCounts[2] ?? 0),
                    const SizedBox(width: 15),
                    _buildDialogReaction('wow', TImages.sorprende, _reactionCounts[3] ?? 0),
                    const SizedBox(width: 15),
                    _buildDialogReaction('dislike', TImages.dislike, _reactionCounts[4] ?? 0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      int idReaccion;
      switch (result) {
        case 'like': idReaccion = 1; break;
        case 'love': idReaccion = 2; break;
        case 'wow': idReaccion = 3; break;
        case 'dislike': idReaccion = 4; break;
        default: idReaccion = 1;
      }

      if (_userReactionId == idReaccion) {
        await _deleteReaction();
      } else {
        if (_userReactionId != null) {
          await _deleteReaction();
        }
        await _sendReactionToServer(idReaccion);
      }
    }
  }

  Future<void> _sendReactionToServer(int idReaccion) async {
    final prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('id_usuario') ?? 0;
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.post(
        Uri.parse('${THttpHelper.baseUrl}/publicacion_reaccion'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'ID_usuario': idUsuario,
          'ID_publicacion': widget.publicacion.id,
          'ID_reaccion': idReaccion,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _userReactionId = idReaccion;
          _reactionCounts[idReaccion] = (_reactionCounts[idReaccion] ?? 0) + 1;
        });
      }
    } catch (e) {
      debugPrint('Error al enviar reacción: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar reacción')),
      );
    }
  }

  Future<void> _deleteReaction() async {
    if (_userReactionId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('id_usuario') ?? 0;
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse('${THttpHelper.baseUrl}/publicacion_reaccion?usuario=$idUsuario&publicacion=${widget.publicacion.id}'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final reacciones = jsonDecode(response.body);
        if (reacciones.isNotEmpty) {
          final idReaccion = reacciones[0]['ID_publicacion_reaccion'];
          
          final deleteResponse = await http.delete(
            Uri.parse('${THttpHelper.baseUrl}/publicacion_reaccion/$idReaccion'),
            headers: {
              "Authorization": "Bearer $token",
            },
          );

          if (deleteResponse.statusCode == 200) {
            setState(() {
              _reactionCounts[_userReactionId!] = (_reactionCounts[_userReactionId!] ?? 1) - 1;
              _userReactionId = null;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error al eliminar reacción: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar reacción')),
      );
    }
  }

  Widget _buildDialogReaction(String reaction, String image, int count) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, reaction),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            width: 45,
            height: 45,
          ),
          const SizedBox(height: 2),
          Text(
            _getReactionName(reaction),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsButton() {
    return GestureDetector(
      onTap: _toggleComments,
      child: Row(
        children: [
          Icon(Icons.mode_comment_outlined, size: TSizes.iconLg),
          const SizedBox(width: TSizes.xs),
          Text(
            '${widget.publicacion.comentarios?.length ?? 0}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 10,
      left: 12,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
        ),
        child: IconButton(
          icon: Icon(Iconsax.arrow_left_2_copy, color: TColors.black, size: TSizes.iconLg),
          onPressed: () => NavigationController.to.popPage(),
        ),
      ),
    );
  }

  Widget _buildPanelOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          if (_showComments) _toggleComments();
          if (_showOptions) _toggleOptions();
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          color: Colors.black.withOpacity(0.4),
        ),
      ),
    );
  }

  String _getReactionName(String reaction) {
    switch (reaction) {
      case 'like': return 'Me gusta';
      case 'love': return 'Me encanta';
      case 'wow': return 'Me asombra';
      case 'dislike': return 'No me gusta';
      default: return 'Me gusta';
    }
  }

  String? _getReactionNameFromId(int? id) {
    switch (id) {
      case 1: return 'like';
      case 2: return 'love';
      case 3: return 'wow';
      case 4: return 'dislike';
      default: return null;
    }
  }

  int _getTotalReactions() {
    return _reactionCounts.values.reduce((a, b) => a + b);
  }

  Widget _buildReactionIcon(String reaction, {double size = 24, bool isSelected = false}) {
    String assetPath;

    switch (reaction) {
      case 'like': assetPath = isSelected ? TImages.like_q : TImages.like_q; break;
      case 'love': assetPath = isSelected ? TImages.love_q : TImages.love_q; break;
      case 'wow': assetPath = isSelected ? TImages.sorprende_q : TImages.sorprende_q; break;
      case 'dislike': assetPath = isSelected ? TImages.dislike_q : TImages.dislike_q; break;
      default: assetPath = TImages.like_q;
    }

    return Image.asset(
      assetPath,
      width: size,
      height: size,
    );
  }
}