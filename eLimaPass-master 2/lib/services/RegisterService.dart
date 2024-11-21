import 'dart:convert';

import 'package:http/http.dart' as http;

import '../util/constants.dart';

class RegisterService {
  static const String _baseUrl = '${BACKEND_URL}elimapass/v1/signup/';

  Future<void> register(String dni, String email, String nombres,
      String apellidos, String password, String numTarjeta) async {
    var body = {
      'dni': dni,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'password': password
    };

    if (numTarjeta.isNotEmpty) {
      body['num_tarjeta'] = numTarjeta;
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return;
    }

    if (response.statusCode == 400) {
      throw Exception('DNI o tarjeta ya existen');
    }

    throw Exception('Ha ocurrido un error desconocido');
  }
}
