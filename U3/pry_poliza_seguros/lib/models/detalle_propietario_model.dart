// detalle_propietario_model.dart
class DetallePropietario {
  final String propietario;
  final String modeloAuto;
  final double valorSeguroAuto;
  final int edadPropietario;
  final int accidentes;
  final double costoTotal;

  DetallePropietario({
    required this.propietario,
    required this.modeloAuto,
    required this.valorSeguroAuto,
    required this.edadPropietario,
    required this.accidentes,
    required this.costoTotal,
  });

  factory DetallePropietario.fromJson(Map<String, dynamic> json) {
    return DetallePropietario(
      propietario: json['propietario'],
      modeloAuto: json['modeloAuto'],
      valorSeguroAuto: (json['valorSeguroAuto'] as num).toDouble(),
      edadPropietario: json['edadPropietario'],
      accidentes: json['accidentes'],
      costoTotal: (json['costoTotal'] as num).toDouble(),
    );
  }
}
