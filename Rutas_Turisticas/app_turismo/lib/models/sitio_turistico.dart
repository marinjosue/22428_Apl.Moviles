class SitioTuristico {
  final String id;
  final String nombre;
  final String descripcion;
  final double latitud;
  final double longitud;

  SitioTuristico({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
  });

  factory SitioTuristico.fromMap(Map<String, dynamic> map, String id) {
    return SitioTuristico(
      id: id,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
      latitud: (map['latitud'] ?? 0.0).toDouble(),
      longitud: (map['longitud'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'latitud': latitud,
      'longitud': longitud,
    };
  }
}
