import 'dart:convert';

import 'package:elimapass/models/responses/RutaResponse.dart';
import 'package:http/http.dart' as http;

import '../models/entities/Paradero.dart';
import '../models/responses/ParaderoResponse.dart';
import '../util/constants.dart';

class MapService {
  static const String _baseUrl = '${BACKEND_URL}elimapass/v1/';

  Future<RutaResponse> getRutas() async {
    var url = "${_baseUrl}rutas/";

    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final rutasResponse = RutaResponse.fromJson(json);
      return rutasResponse;
    } else {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }

  Future<List<Paradero>> getParaderos(String id) async {
    String url = "${_baseUrl}paraderos/$id";
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      print(json);
      final paraderos = ParaderoResponse.fromJson(json);
      return paraderos.paraderos;
    } else {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }
}
