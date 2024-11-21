import 'dart:convert';

import 'package:elimapass/models/responses/LoginResponse.dart';
import 'package:elimapass/services/tarjeta_provider.dart';
import 'package:elimapass/util/constants.dart';
import 'package:http/http.dart' as http;

class LoginService {
  TarjetaProvider provider = TarjetaProvider();
  static const String _baseUrl = '${BACKEND_URL}elimapass/v1/login/';

  Future<void> login(String dni, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'dni': dni,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final user = LoginResponse.fromJson(json);
      await provider.saveTarjeta(user);
    } else if (response.statusCode == 401) {
      throw Exception('Credenciales inválidas');
    } else {
      throw Exception('Ha ocurrido un error desconocido. Inténtelo más tarde');
    }
  }
}
