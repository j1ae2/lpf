class Ruta {
  String id;
  String nombre;
  String inicio;
  String fin;

  Ruta(
      {required this.id,
      required this.nombre,
      required this.inicio,
      required this.fin});

  factory Ruta.fromJson(Map<String, dynamic> json) {
    return Ruta(
        id: json['id'],
        nombre: json['nombre'],
        inicio: json['inicio'],
        fin: json['final']);
  }

  // Método para serializar Ruta a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }
}
