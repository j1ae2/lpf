class Viaje {
  final String id;
  final DateTime fechaHora;
  final String ruta;
  final double precioFinal;

  Viaje({
    required this.id,
    required this.fechaHora,
    required this.ruta,
    required this.precioFinal,
  });

  factory Viaje.fromJson(Map<String, dynamic> json) {
    return Viaje(
      id: json['id'],
      fechaHora: DateTime.parse(json['fecha_hora']),
      ruta: json['ruta'],
      precioFinal: json['precio_final'],
    );
  }
}
