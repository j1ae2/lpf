import '../entities/Recarga.dart';

class RecargasResponse {
  final String codigoTarjeta;
  final List<Recarga> recargas;

  RecargasResponse({
    required this.codigoTarjeta,
    required this.recargas,
  });

  factory RecargasResponse.fromJson(Map<String, dynamic> json) {
    var recargasJson = json['recargas'] as List;
    List<Recarga> recargasList =
        recargasJson.map((i) => Recarga.fromJson(i)).toList();

    return RecargasResponse(
      codigoTarjeta: json['codigo_tarjeta'],
      recargas: recargasList,
    );
  }
}
