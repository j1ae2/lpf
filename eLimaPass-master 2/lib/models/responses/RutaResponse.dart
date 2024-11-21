import '../entities/Ruta.dart';

class RutaResponse {
  Map<String, List<Ruta>> rutasPorServicio;

  RutaResponse({required this.rutasPorServicio});

  factory RutaResponse.fromJson(Map<String, dynamic> json) {
    // Mapea cada key del JSON a una lista de rutas
    Map<String, List<Ruta>> rutasPorServicio = {};
    json.forEach((servicio, rutas) {
      rutasPorServicio[servicio] =
          List<Ruta>.from(rutas.map((ruta) => Ruta.fromJson(ruta)));
    });
    return RutaResponse(rutasPorServicio: rutasPorServicio);
  }
}
