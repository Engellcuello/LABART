import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/common/models/publicacion_model.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/navigation_bar.dart';
import 'package:labart/widgets/publicaciones_categoria/tags_edit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostEditorPage extends StatefulWidget {
  final Publicacion publicacion;

  const PostEditorPage({Key? key, required this.publicacion}) : super(key: key);

  @override
  _PostEditorPageState createState() => _PostEditorPageState();
}

class _PostEditorPageState extends State<PostEditorPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  List<String> _selectedTags = [];
  bool _isExplicit = false;
  bool _isSaving = false;
  bool _isDeleting = false;
  bool _showDeleteSheet = false;

  @override
  void initState() {
    super.initState();
    
    _titleController = TextEditingController(text: widget.publicacion.titulo);
    _descriptionController = TextEditingController(text: widget.publicacion.descripcion);
    _isExplicit = widget.publicacion.esExplicita;
    print('Título: ${widget.publicacion.titulo}');
    print('Descripción: ${widget.publicacion.descripcion}');
    print('Imagen: ${widget.publicacion.imagenUrl}');
    print('esExplicita: ${widget.publicacion.esExplicita}');
  }

  bool _hasRealChanges() {
    return _titleController.text != widget.publicacion.titulo ||
        _descriptionController.text != widget.publicacion.descripcion ||
        _isExplicit != widget.publicacion.esExplicita ||
        _selectedTags.isNotEmpty;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildDeleteConfirmationSheet() {
    final dark = THelperFunctions.isDarkMode(context);
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      bottom: _showDeleteSheet ? 0 : -MediaQuery.of(context).size.height * 0.4,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        decoration: BoxDecoration(
          color: dark ? TColors.blakfondo : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¿Quieres eliminar la publicación?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Esta acción no se puede deshacer. La publicación se eliminará permanentemente.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: dark
                    ? const Color.fromARGB(255, 168, 168, 168)
                    : const Color.fromARGB(255, 100, 100, 100),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 130,
                  child: OutlinedButton(
                    onPressed: _toggleDeleteSheet,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                          color: dark ? Colors.white : Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  width: 130,
                  child: InkWell(
                    onTap: () {
                      PublicacionServices.eliminarPublicacion(id: widget.publicacion.id);
                      _toggleDeleteSheet();
                      _deletePost(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(157, 100, 180, 246),
                            Color.fromARGB(255, 219, 77, 255),
                            Color.fromARGB(159, 211, 170, 212),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }


  void _toggleDeleteSheet() {
    setState(() {
      _showDeleteSheet = !_showDeleteSheet;
    });
  }

  Future<void> _deletePost(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    
    try {
      final success = await PublicacionServices.eliminarPublicacion(id: widget.publicacion.id);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cambios guardados correctamente!')),
        );
        Get.offAll(() => NavigationMenu());// Retorna 'true' para indicar éxito
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _savePost(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    if (!_hasRealChanges()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se detectaron cambios para guardar')),
      );
      return;
    }

    setState(() => _isSaving = true);
    
    try {
      // Mostrar loader
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Llamar al servicio para actualizar
      final success = await PublicacionServices.actualizarPublicacion(
        id: widget.publicacion.id,
        titulo: _titleController.text,
        imagenUrl: widget.publicacion.imagenUrl,
        descripcion: _descriptionController.text,
        esExplicita: _isExplicit,
        idusuario: widget.publicacion.usuarioId,
        etiquetas: _selectedTags,
      );

      

      if (success && mounted) {
        final updatedPost = Publicacion(
          id: widget.publicacion.id,
          titulo: _titleController.text,
          descripcion: _descriptionController.text,
          fecha: widget.publicacion.fecha,
          imagenUrl: widget.publicacion.imagenUrl,
          esExplicita: _isExplicit,
          usuarioId: widget.publicacion.usuarioId,
          usuario: widget.publicacion.usuario,
          comentarios: widget.publicacion.comentarios,
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cambios guardados correctamente!')),
        );
        
        // Cerrar loader
        if (mounted) {
          Navigator.pop(context); // Cierra loader
          Navigator.pop(context, true); // Cierra la pantalla actual (puedes retornar un valor si quieres)
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar loader si hay error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar cambios: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _navigateToTagsEditor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TagsEditorPage(selectedTags: _selectedTags),
      ),
    );

    if (result != null && result is List<String>) {
      setState(() {
        _selectedTags = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: dark ? Colors.white : Colors.black),
          // onPressed: () => Navigator.of(context).pop(), // Cambia esto
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Editar Publicación',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        actions: [
          InkWell(
            onTap: _isSaving ? null : _toggleDeleteSheet,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _isDeleting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Iconsax.trash_copy, color: dark ? Colors.white : Colors.black, size: 24),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Imagen con cache
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: widget.publicacion.imagenUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: dark ? Colors.grey[800] : Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              color: dark ? Colors.white54 : Colors.grey,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: dark ? Colors.grey[800] : Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.broken_image, size: 50, color: dark ? Colors.white54 : Colors.grey),
                              const SizedBox(height: 8),
                              Text('Imagen no disponible', style: TextStyle(color: dark ? Colors.white54 : Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Título',
                      hintStyle: TextStyle(color: dark ? Colors.white54 : Colors.grey),
                      hintText: 'Añade un título para tu publicación',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un título';
                      }
                      if (value.length > 50) {
                        return 'El título no puede exceder 50 caracteres';
                      }
                      return null;
                    },
                    maxLength: 50,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      hintStyle: TextStyle(color: dark ? Colors.white54 : Colors.grey),
                      hintText: 'Cuéntanos más sobre tu publicación...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.description),
                    ),
                    maxLines: 3,
                    maxLength: 500,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una descripción';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  InkWell(
                    onTap: _navigateToTagsEditor,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: dark ? Colors.grey[700]! : Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Etiquetas', style: TextStyle(fontSize: 16)),
                          Row(
                            children: [
                              if (_selectedTags.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${_selectedTags.length} ${_selectedTags.length == 1 ? 'etiqueta' : 'etiquetas'}',
                                    style: TextStyle(
                                      color: dark ? const Color.fromARGB(181, 150, 150, 150) : const Color.fromARGB(181, 66, 66, 66),
                                    ),
                                  ),
                                ),
                              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      const Icon(Icons.warning_amber, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Text('Contenido Explícito', style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      Switch(
                        value: _isExplicit,
                        onChanged: (value) {
                          setState(() {
                            _isExplicit = value;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _savePost(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(157, 100, 180, 246),
                              Color.fromARGB(255, 219, 77, 255),
                              Color.fromARGB(159, 211, 170, 212),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Guardar Cambios',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (_showDeleteSheet)
            GestureDetector(
              onTap: _toggleDeleteSheet,
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          
          _buildDeleteConfirmationSheet(),
        ],
      ),
    );
  }
}