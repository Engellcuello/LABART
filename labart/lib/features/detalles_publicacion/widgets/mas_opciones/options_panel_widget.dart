import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/common/models/publicacion_model.dart';
import 'package:labart/common/functions/Function_downloads/descargarImagen.dart';
import 'package:labart/widgets/publicaciones_categoria/editar_publicacion.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class OptionsPanelWidget extends StatefulWidget {
  final bool isDark;
  final VoidCallback onClose;
  final String imageUrl;
  final Publicacion publicacion;
  final int id_usuario_publicacion;

  const OptionsPanelWidget({
    super.key,
    required this.isDark,
    required this.onClose,
    required this.imageUrl, 
    required this.publicacion, 
    required this.id_usuario_publicacion,
  });

  @override
  State<OptionsPanelWidget> createState() => _OptionsPanelWidgetState();
}

class _OptionsPanelWidgetState extends State<OptionsPanelWidget> {
  bool _isOwner = false;
  bool _isLoading = true;

  @override
  @override
void initState() {
  super.initState();
  _checkIfOwner();
}

  Future<void> _checkIfOwner() async {
    final prefs = await SharedPreferences.getInstance();
    final idUsuario = prefs.getInt('id_usuario') ?? 0;
    
    setState(() {
      _isOwner = idUsuario == widget.id_usuario_publicacion;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Drag handle
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta! > 5) {
                widget.onClose();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.isDark ? Colors.white54 : Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.close, size: 24, color: Theme.of(context).iconTheme.color),
                  onPressed: widget.onClose,
                ),
                const SizedBox(width: 8),
                Text(
                  "Opciones de publicación",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          if (_isLoading)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else
            Expanded(
              child: Column(
                children: [
                  if (_isOwner) ...[
                    _buildOptionTile(
                      icon: Iconsax.edit_2_copy,
                      title: "Editar publicación",
                      onTap: () {
                        widget.onClose();
                        _navigateToEditPost(context);
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                  ],
                  _buildOptionTile(
                    icon: Iconsax.receive_square_copy,
                    title: "Descargar imagen",
                    onTap: () async {
                      final handler = DescargarImagenHandler(
                        widget.imageUrl, 
                        widget.publicacion.usuario?.nombre ?? "LabArt", 
                        widget.publicacion.titulo
                      );
                      await handler.descargarImagen(context, (file) {});
                      widget.onClose();
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildOptionTile(
                    icon: Icons.share_outlined,
                    title: "Compartir publicación",
                    onTap: () {
                      widget.onClose();
                      _compartirPublicacion(context);
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _buildOptionTile(
                    icon: Iconsax.info_circle,
                    title: "Reportar publicación",
                    onTap: widget.onClose,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 26, color: color ?? Theme.of(context).iconTheme.color),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      minLeadingWidth: 24,
    );
  }

  void _navigateToEditPost(BuildContext context) {

    // Navigator.of(context).pop(); 
    // Get.to(() => PostEditorPage(publicacion: widget.publicacion));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostEditorPage(publicacion: widget.publicacion),
      ),
    );

  }
  Future<void> _compartirPublicacion(BuildContext context) async {
    final compartidor = CompartidorPublicacion(
      publicacion: widget.publicacion,
      imageUrl: widget.imageUrl,
    );
    await compartidor.compartir(context);
  }
}

class CompartidorPublicacion {
  final Publicacion publicacion;
  final String imageUrl;

  CompartidorPublicacion({
    required this.publicacion,
    required this.imageUrl,
  });

  Future<void> compartir(BuildContext context) async {
    try {
      final tempFile = await _descargarImagenTemporal();
      final textoCompartir = 
        '${publicacion.titulo}\n\n'
        '${publicacion.descripcion}\n\n'
        'Publicado por: ${publicacion.usuario?.nombre ?? "Usuario LabArt"}\n\n'
        'Descarga la app: https://labart.com';

      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: textoCompartir,
      );

      await tempFile.delete();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al compartir: ${e.toString()}')),
        );
      }
    }
  }

  Future<File> _descargarImagenTemporal() async {
    final response = await http.get(Uri.parse(imageUrl));
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/compartir_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await tempFile.writeAsBytes(response.bodyBytes);
    return tempFile;
  }
}