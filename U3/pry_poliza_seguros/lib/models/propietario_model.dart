class Propietario {
  final int id;
  final String nombreCompleto;
  final int edad;
  final List<int> automovilIds;

  Propietario({
    required this.id,
    required this.nombreCompleto,
    required this.edad,
    required this.automovilIds,
  });

  factory Propietario.fromJson(Map<String, dynamic> json) {
    return Propietario(
      id: json['id'],
      nombreCompleto: json['nombreCompleto'],
      edad: json['edad'],
      automovilIds: List<int>.from(json['automovilIds']),
    );
  }
}
