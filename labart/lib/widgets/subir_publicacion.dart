import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:labart/common/dialogs/succes_screen/succes_error_dialog.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/text_strings.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/categorias_dialog.dart';
import 'package:labart/widgets/seleccionar_categorias_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:labart/widgets/categoria_model.dart';
import 'package:http_parser/http_parser.dart';

class NuevaPublicacionScreen extends StatefulWidget {
  @override
  _NuevaPublicacionScreenState createState() => _NuevaPublicacionScreenState();
}

class _NuevaPublicacionScreenState extends State<NuevaPublicacionScreen> {
  List<Categoria> _categoriasSeleccionadas = [];
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  bool _esExplicito = false;
  File? _imagen;
  bool _isSubmitting = false; // Nuevo estado para controlar el envío

  Future<void> _seleccionarImagen() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        setState(() {
          _imagen = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('¡Ocurrió una excepción al seleccionar la imagen!');
    }
  }

  void _mostrarDialogoExplicito() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            const SizedBox(width: 8),
            Text('Contenido explícito'),
          ],
        ),
        content: Text(
          'Marca esta opción si tu publicación contiene contenido sensible, violento o sexual. '
          'No marcarlo puede llevar al baneo de tu cuenta.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _subirCategoriasPublicacion(int idPublicacion) async {
    try {
      final uri = Uri.parse('${THttpHelper.baseUrl}/publicacion_categoria');
      final client = http.Client();
      
      // Preparamos todas las solicitudes
      final requests = _categoriasSeleccionadas.map((categoria) async {
        final response = await client.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'ID_publicacion': idPublicacion,
            'ID_categoria': categoria.id,
          }),
        );
        
        if (response.statusCode != 200) {
          throw Exception('Error al asociar categoría ${categoria.id}');
        }
      }).toList();

      // Ejecutamos todas las solicitudes en paralelo
      await Future.wait(requests);
      
      print('Categorías asociadas correctamente');
    } catch (e) {
      print('Error al subir categorías: $e');
      // Puedes mostrar un mensaje al usuario si lo deseas
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Publicación creada pero hubo un error con algunas categorías')),
      );
    }
  }

  Future<void> _publicar() async {
    // Si ya está enviando, no hacer nada
    if (_isSubmitting) return;
    
    // Validar campos requeridos
    if (_tituloController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingresa un título')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true; // Activar estado de envío
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final idUsuario = prefs.getInt('id_usuario') ?? 0;

      final uri = Uri.parse('${THttpHelper.baseUrl}/publicacion');
      final request = http.MultipartRequest('POST', uri)
        ..fields['Titulo_publicacion'] = _tituloController.text
        ..fields['Descripcion_publicacion'] = _descripcionController.text
        ..fields['Fecha_Publicacion'] = DateTime.now().toIso8601String()
        ..fields['Cont_Explicit_publi'] = _esExplicito.toString()
        ..fields['ID_usuario'] = idUsuario.toString();

      if (_imagen != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'Img_publicacion',
            _imagen!.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      final response = await request.send();

      if (!mounted) return;

      if (response.statusCode == 201) {
        final body = await response.stream.bytesToString();
        final data = jsonDecode(body);

        final idPublicacion = data['ID_publicacion']; 
        
        if (_categoriasSeleccionadas.isNotEmpty) {
          await _subirCategoriasPublicacion(idPublicacion);
        }
        
        // Mostrar animación de éxito
        await showResultDialog(
          isSuccess: true,
          context: context,
          successText: '¡Publicación creada exitosamente!',
          onSuccess: () {
            // Limpiar el formulario
            _tituloController.clear();
            _descripcionController.clear();
            setState(() {
              _imagen = null;
              _esExplicito = false;
              _categoriasSeleccionadas = [];
            });
            return Future.value();
          },
        );
      } else {
        print('Error al publicar: ${response.statusCode}');
        await showResultDialog(
          isSuccess: false,
          context: context,
          errorText: 'Error al subir la publicación',
        );
      }
    } catch (e) {
      print('Excepción al publicar: $e');
      await showResultDialog(
        isSuccess: false,
        context: context,
        errorText: 'Error inesperado al publicar',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false; // Desactivar estado de envío
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_2_copy),
          color: dark? Colors.white : Colors.black,
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
        ),
        centerTitle: true,
        title: Text(TTexts.tituloNuevaPublicacion, style: textTheme.titleLarge),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _imagen == null ? _seleccionarImagen : null,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 180,
                    maxHeight: 180,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: 180,
                    width: 180,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: _imagen == null
                          ? Container(
                              key: const ValueKey('empty'),
                              padding: const EdgeInsets.all(16),
                              constraints: const BoxConstraints(
                                maxWidth: 180,
                                maxHeight: 180,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.outlineVariant,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Iconsax.gallery_add, size: 60),
                                  const SizedBox(height: 12),
                                  Text('Sube tu imagen', style: Theme.of(context).textTheme.bodyLarge),
                                ],
                              ),
                            )
                          : ConstrainedBox(
                              key: const ValueKey('image'),
                              constraints: const BoxConstraints(
                                maxWidth: 180,
                                maxHeight: 180,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  fit: StackFit.loose,
                                  alignment: Alignment.topRight,
                                  children: [
                                    Image.file(
                                      _imagen!,
                                      fit: BoxFit.contain,
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: InkWell(
                                        onTap: _seleccionarImagen,
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.6),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    )
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  value: _esExplicito,
                  onChanged: (value) {
                    setState(() {
                      _esExplicito = value ?? false;
                    });
                  },
                ),
                Expanded(child: Text('Contenido explícito', style: textTheme.bodyMedium)),
                IconButton(
                  onPressed: _mostrarDialogoExplicito,
                  icon: const Icon(Iconsax.info_circle),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (_categoriasSeleccionadas.isEmpty) {
                    final result = await Navigator.push<List<Categoria>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeleccionarCategoriasScreen(
                          categoriasSeleccionadas: _categoriasSeleccionadas,
                        ),
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        _categoriasSeleccionadas = result;
                      });
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => CategoriasDialog(
                        categoriasSeleccionadas: _categoriasSeleccionadas,
                        onCategoriasUpdated: (nuevasCategorias) {
                          setState(() {
                            _categoriasSeleccionadas = nuevasCategorias;
                          });
                        },
                      ),
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _categoriasSeleccionadas.isEmpty ? Icons.category_outlined : Icons.checklist,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _categoriasSeleccionadas.isEmpty
                            ? 'Seleccionar categorías'
                            : '${_categoriasSeleccionadas.length} categorias seleccionadas',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _isSubmitting ? null : _publicar, // Deshabilitar si está enviando
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _isSubmitting 
                    ? null // No mostrar gradiente si está cargando
                    : const LinearGradient(
                        colors: [
                          Color(0xFF64B4F6),
                          Color(0xFFDB4DFF),
                          Color(0xFFD3AAD4),
                        ],
                      ),
                  color: _isSubmitting ? Colors.grey : null, // Mostrar gris si está cargando
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Publicar',
                          style: textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}