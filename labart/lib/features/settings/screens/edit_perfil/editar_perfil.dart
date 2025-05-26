import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({Key? key}) : super(key: key);

  @override
  _EditarPerfilScreenState createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  File? _imagen;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  // Datos del usuario
  String _nombreUsuario = '';
  String _correoUsuario = '';
  int _idSexo = 1;
  int? _idUsuario;
  String? _imgUsuarioUrl;

  bool _cargando = true;
  bool _guardando = false;
  bool _hayCambios = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosUsuario();
  }

  Future<void> _cargarDatosUsuario() async {
    if (!mounted) return;

    setState(() {
      _cargando = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final idUsuario = prefs.getInt('id_usuario') ?? 0;
      _idUsuario = idUsuario;

      final response = await http.get(
        Uri.parse('${THttpHelper.baseUrl}/usuario/$idUsuario'),
      );

      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        setState(() {
          _nombreUsuario = data['Nombre_usuario'] ?? '';
          _correoUsuario = data['correo_usuario'] ?? '';
          _idSexo = data['ID_sexo'] ?? 1;
          _imgUsuarioUrl = data['Img_usuario'];
          _cargando = false;
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error al cargar los datos del usuario')),
          );
          setState(() {
            _cargando = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  Future<void> _seleccionarImagen() async {
    try {
      
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _imagen = File(pickedFile.path);
          _hayCambios = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al seleccionar la imagen')),
        );
      }
    }
  }

  Future<void> _guardarCambios() async {
    if (!_hayCambios && _imagen == null) {
      _mostrarMensaje('No hay cambios para guardar');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _guardando = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final idUsuario = prefs.getInt('id_usuario') ?? 0;
      var request = http.MultipartRequest(
        'put',
        Uri.parse('${THttpHelper.baseUrl}/usuario/$idUsuario?_method=PUT'),
      );

      // Agregar datos del formulario
      request.fields['ID_usuario'] = _idUsuario.toString();
      request.fields['Nombre_usuario'] = _nombreUsuario;
      request.fields['ID_sexo'] = _idSexo.toString();

      // Agregar imagen si se seleccionó una nueva
      if (_imagen != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'Img_usuario',
            _imagen!.path,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        _mostrarMensaje('Perfil actualizado correctamente');
        setState(() {
          _hayCambios = false;
        });
      } else {
        _mostrarMensaje('Error al actualizar el perfil');
      }
    } catch (e) {
      _mostrarMensaje('Error: ${e.toString()}');
    } finally {
      setState(() {
        _guardando = false;
      });
    }
  }

  void _mostrarMensaje(String mensaje) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left), // Asegúrate de tener el paquete iconsax
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Editar Perfil', style: TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                onChanged: () {
                  setState(() {
                    _hayCambios = true;
                  });
                },
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Foto de perfil
                    GestureDetector(
                      onTap: _seleccionarImagen,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                            ),
                            child: ClipOval(
                              child: _imagen != null
                                  ? Image.file(_imagen!, fit: BoxFit.cover)
                                  : _imgUsuarioUrl != null
                                      ? Image.network(
                                          _imgUsuarioUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.person, size: 60, color: Colors.grey);
                                          },
                                        )
                                      : const Icon(Icons.person, size: 60, color: Colors.grey),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.edit, size: 18, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Nombre de usuario
                    TextFormField(
                      initialValue: _nombreUsuario,
                      decoration: InputDecoration(
                        labelText: 'Nombre de usuario',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu nombre de usuario';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _nombreUsuario = value;
                      },
                    ),

                    const SizedBox(height: 20),
                    // Correo electrónico (solo lectura)
                    TextFormField(
                      initialValue: _correoUsuario,
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      readOnly: true,
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    // Selección de sexo
                    DropdownButtonFormField<int>(
                      value: _idSexo,
                      decoration: InputDecoration(
                        labelText: 'Sexo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.people_outline),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 1,
                          child: Text('Masculino'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text('Femenino'),
                        ),
                        DropdownMenuItem(
                          value: 3,
                          child: Text('Otro'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _idSexo = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    // Botón de guardar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _guardando ? null : _guardarCambios,
                        child: _guardando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Guardar Cambios'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}