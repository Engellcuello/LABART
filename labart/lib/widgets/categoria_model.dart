class Categoria {
  final int id;
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  bool seleccionada;

  Categoria({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    this.seleccionada = false,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['ID_categoria'],
      nombre: json['Nombre_categoria'],
      descripcion: json['Descripcion_categoria'],
      imagenUrl: json['Img_categoria'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'imagenUrl': imagenUrl,
    'seleccionada': seleccionada,
  };
} 