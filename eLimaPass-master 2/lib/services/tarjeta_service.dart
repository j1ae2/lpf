import 'dart:convert';

import 'package:elimapass/models/entities/Recarga.dart';
import 'package:elimapass/models/entities/Viaje.dart';
import 'package:elimapass/models/responses/RecargaResponse.dart';
import 'package:elimapass/models/responses/ViajesResponse.dart';
import 'package:elimapass/services/tarjeta_provider.dart';
import 'package:http/http.dart' as http;

import '../util/constants.dart';

class TarjetaService {
  static const String _baseUrl = '${BACKEND_URL}elimapass/v1/tarjetas/';
  TarjetaProvider provider = TarjetaProvider();

  Future<double> getSaldo() async {
    String? tarjetaId = await provider.getTarjeta();

    if (tarjetaId == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "$_baseUrl$tarjetaId/saldo/";

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final saldo = json["saldo"];
      return saldo;
    } else {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }

  Future<List<Viaje>> getViajes() async {
    String? tarjetaId = await provider.getTarjeta();

    if (tarjetaId == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "$_baseUrl$tarjetaId/viajes/";

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final viajesResponse = ViajesResponse.fromJson(json);
      return viajesResponse.viajes;
    } else {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }

  Future<void> setLimite(double limite) async {
    String? tarjetaId = await provider.getTarjeta();

    if (tarjetaId == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "$_baseUrl$tarjetaId/cambiar-limite/";

    var body = {"limite": limite};

    final response =
        await http.put(Uri.parse(url), body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }

  Future<List<Recarga>> getRecargas() async {
    String? tarjetaId = await provider.getTarjeta();
    if (tarjetaId == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "$_baseUrl$tarjetaId/recargas/";

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final recargasResponse = RecargasResponse.fromJson(json);
      return recargasResponse.recargas;
    } else {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }

  Future<bool> setRecarga(double monto, String medio_pago) async {
    String? tarjetaId = await provider.getTarjeta();
    if (tarjetaId == null) {
      throw Exception("Ha ocurrido un error");
    }

    var url = "${BACKEND_URL}elimapass/v1/recargar/";

    var body = {
      "codigo_tarjeta": tarjetaId,
      "monto_recargado": monto,
      "medio_pago": medio_pago
    };

    final response =
        await http.post(Uri.parse(url), body: jsonEncode(body), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 201) {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
    print(response.body);
    return true;
  }
}
