import 'package:labart/common/models/publicacion_model.dart';

class Comentario {
  final int ID_comentario;
  final String Contenido_comentario;
  final DateTime Fecha_comentario;
  final int ID_usuario;
  final int ID_publicacion;

  Comentario({
    required this.ID_comentario,
    required this.Contenido_comentario,
    required this.Fecha_comentario,
    required this.ID_usuario,
    required this.ID_publicacion,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      ID_comentario: json['ID_comentario'],
      Contenido_comentario: json['Contenido_comentario'],
      Fecha_comentario: DateTime.parse(json['Fecha_comentario']),
      ID_usuario: json['ID_usuario'],
      ID_publicacion: json['ID_publicacion'],
    );
  }
}

class ComentarioConUsuario {
  final Comentario comentario;
  final Usuario usuario;

  ComentarioConUsuario({
    required this.comentario,
    required this.usuario,
  });
}