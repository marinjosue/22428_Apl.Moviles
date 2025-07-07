class Comentario {
  final String id;
  final String sitioId;
  final String usuarioId;
  final String nombreUsuario;
  final String texto;
  final double calificacion;
  final DateTime fecha;

  Comentario({
    required this.id,
    required this.sitioId,
    required this.usuarioId,
    required this.nombreUsuario,
    required this.texto,
    required this.calificacion,
    required this.fecha,
  });

  factory Comentario.fromMap(Map<String, dynamic> map, String id) {
    return Comentario(
      id: id,
      sitioId: map['sitioId'],
      usuarioId: map['usuarioId'],
      nombreUsuario: map['nombreUsuario'],
      texto: map['texto'],
      calificacion: map['calificacion'].toDouble(),
      fecha: DateTime.parse(map['fecha']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sitioId': sitioId,
      'usuarioId': usuarioId,
      'nombreUsuario': nombreUsuario,
      'texto': texto,
      'calificacion': calificacion,
      'fecha': fecha.toIso8601String(),
    };
  }
}
