class User {
  final String id;
  final String dni;
  final String nombres;
  final String apellidos;
  final String email;

  User({
    required this.id,
    required this.dni,
    required this.nombres,
    required this.apellidos,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      dni: json['dni'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      email: json['email'],
    );
  }
}