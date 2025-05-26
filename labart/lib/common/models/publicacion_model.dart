

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
      ID_comentario: json['ID_comentario'] as int,
      Contenido_comentario: json['Contenido_comentario'] as String,
      Fecha_comentario: DateTime.parse(json['Fecha_comentario']),
      ID_usuario: json['ID_usuario'] as int,
      ID_publicacion: json['ID_publicacion'] as int,
    );
  }
}


class Usuario {
  final int id;
  final String nombre;
  final String imgUsuario;

  Usuario({
    required this.id,
    required this.nombre,
    required this.imgUsuario,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['ID_usuario'] ?? 0,
      nombre: json['Nombre_usuario'] ?? 'Usuario',
      imgUsuario: json['Img_usuario'] ?? '', // Cadena vacía si es null
    );
  }
}


class Publicacion {
  final int id;
  final String titulo;
  final DateTime fecha;
  final String descripcion;
  final String imagenUrl;
  final bool esExplicita;
  final int usuarioId;
  Usuario? usuario;
  List<ComentarioConUsuario>? comentarios; // Cambiado a ComentarioConUsuario

  Publicacion({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.descripcion,
    required this.imagenUrl,
    required this.esExplicita,
    required this.usuarioId,
    this.usuario,
    this.comentarios,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['ID_publicacion'],
      titulo: json['Titulo_publicacion'],
      fecha: DateTime.parse(json['Fecha_Publicacion']),
      descripcion: json['Descripcion_publicacion'],
      imagenUrl: json['Img_publicacion'],
      esExplicita: (json['Cont_Explicit_publi'] ?? 0) == 1,
      usuarioId: json['ID_usuario'],
      comentarios: null,
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



class Recomendacion {
  final int idPublicacion;
  final String titulo;
  final String descripcion;
  final String imagenUrl;
  final bool esExplicita;
  final int usuarioId;
  final DateTime fechaPublicacion;

  Recomendacion({
    required this.idPublicacion,
    required this.titulo,
    required this.descripcion,
    required this.imagenUrl,
    required this.fechaPublicacion,
    required this.esExplicita,
    required this.usuarioId,
  });

  factory Recomendacion.fromJson(Map<String, dynamic> json) {
    return Recomendacion(
      idPublicacion: json['ID_publicacion'],
      titulo: json['Titulo_publicacion'],
      descripcion: json['Descripcion_publicacion'],
      imagenUrl: json['Img_publicacion'],
      esExplicita: (json['esExplicita'] ?? 0) == 1,
      usuarioId: json['idUsuario'],
      fechaPublicacion: DateTime.parse(json['Fecha_Publicacion']),
    );
  }
}