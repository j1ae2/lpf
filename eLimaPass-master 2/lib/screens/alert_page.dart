import 'package:elimapass/services/notification_service.dart';
import 'package:elimapass/services/tarjeta_service.dart';
import 'package:flutter/material.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final TarjetaService _tarjetaService = TarjetaService();

  Future<void> onSubmit() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (_formKey.currentState!.validate()) {
      // Acción al enviar la cantidad numérica
      double saldoMinimo = double.parse(_controller.text);

      // Guardar el saldo mínimo configurado
      await _tarjetaService.provider.setSaldoMinimo(saldoMinimo);

      try {
        await _tarjetaService.setLimite(saldoMinimo);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Ha ocurrido un error. Inténtelo más tarde")),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cantidad guardada: S/. $saldoMinimo")),
      );
      showNotification("Alerta configurada",
          "Se ha configurado una alerta de saldo bajo de S/. $saldoMinimo");
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0XFF405f90),
        title: const Center(
          child: Text(
            "Alerta de saldo bajo",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Center(
        heightFactor: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Esto asegura que el formulario ocupe el mínimo espacio necesario
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Ingrese el límite de alerta",
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("¿Para qué sirve esta alerta?"),
                          content: const Text(
                            "Esta alerta sirve para establecer un saldo mínimo en la tarjeta. "
                            "Una vez que el saldo de la tarjeta llegue a este mínimo o sea menor, "
                            "se enviará una notificación a su celular avisando sobre el saldo bajo.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cerrar"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                // Container para limitar el ancho del campo de texto
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Color(0xffffb4ab)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                      hintText: 'Saldo',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: const Color(0xff111318).withOpacity(0.3),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xff111318),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor ingrese una cantidad";
                      }
                      if (int.tryParse(value) == null) {
                        return "Ingrese un número válido";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFFFFFFFF),
                    foregroundColor: const Color(0xff111318),
                    fixedSize: const Size(125, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: onSubmit,
                  child: const Text(
                    "Guardar",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
