
class UsuarioModel {
  final String username;
  final String password;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String email;
  final String phone;
  final String postalCode;

  UsuarioModel({
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.email,
    required this.phone,
    required this.postalCode,
  });

  /// Convierte desde una línea de archivo separada por comas
  factory UsuarioModel.fromCsv(String csvLine) {
    final parts = csvLine.split(',');
    return UsuarioModel(
      username: parts[0],
      password: parts[1],
      firstName: parts[2],
      lastName: parts[3],
      address: parts[4],
      city: parts[5],
      email: parts[6],
      phone: parts[7],
      postalCode: parts[8],
    );
  }

  /// Convierte a una línea para guardar en archivo
  String toCsv() {
    return '$username,$password,$firstName,$lastName,$address,$city,$email,$phone,$postalCode';
  }
}
