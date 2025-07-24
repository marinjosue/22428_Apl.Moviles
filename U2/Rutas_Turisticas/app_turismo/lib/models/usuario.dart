class Usuario {
  final String id;
  final String email;
  final String nombre;
  final List<String> sitiosFavoritos;
  final DateTime fechaRegistro;

  Usuario({
    required this.id,
    required this.email,
    required this.nombre,
    required this.sitiosFavoritos,
    required this.fechaRegistro,
  });

  factory Usuario.fromMap(Map<String, dynamic> map, String id) {
    return Usuario(
      id: id,
      email: map['email'] ?? '',
      nombre: map['nombre'] ?? '',
      sitiosFavoritos: List<String>.from(map['sitiosFavoritos'] ?? []),
      fechaRegistro: DateTime.parse(map['fechaRegistro']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nombre': nombre,
      'sitiosFavoritos': sitiosFavoritos,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }
}
