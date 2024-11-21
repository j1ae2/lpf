class Recarga {
  final String id;
  final DateTime fechaHora;
  final double monto;
  final String medioPago;

  Recarga({
    required this.id,
    required this.fechaHora,
    required this.monto,
    required this.medioPago,
  });

  factory Recarga.fromJson(Map<String, dynamic> json) {
    return Recarga(
      id: json['id'],
      fechaHora: DateTime.parse(json['fecha']),
      monto: json['monto_recargado'],
      medioPago: json['medio_pago'],
    );
  }
}
