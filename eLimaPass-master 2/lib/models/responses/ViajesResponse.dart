import '../entities/Viaje.dart';

class ViajesResponse {
  final String codigoTarjeta;
  final List<Viaje> viajes;

  ViajesResponse({
    required this.codigoTarjeta,
    required this.viajes,
  });

  factory ViajesResponse.fromJson(Map<String, dynamic> json) {
    var viajesJson = json['viajes'] as List;
    List<Viaje> viajesList = viajesJson.map((i) => Viaje.fromJson(i)).toList();

    return ViajesResponse(
      codigoTarjeta: json['codigo_tarjeta'],
      viajes: viajesList,
    );
  }
}
