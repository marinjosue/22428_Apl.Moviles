class Usuario {
  final String username;
  final String password;

  Usuario({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}
