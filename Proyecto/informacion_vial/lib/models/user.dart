class User {
  final int? id;
  final String email;
  final String name;
  final String? password;

  User({
    this.id,
    required this.email, 
    required this.name, 
    this.password
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'email': email,
      'name': name,
      if (password != null) 'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
}
