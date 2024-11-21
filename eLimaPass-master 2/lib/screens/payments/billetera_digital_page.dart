import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '/services/tarjeta_service.dart';
import '../../widgets/PaymentDialog.dart';

class BilleteraDigitalPage extends StatefulWidget {
  final double montoARecargar;
  const BilleteraDigitalPage({super.key, required this.montoARecargar});

  @override
  State<StatefulWidget> createState() {
    return _BilleteraDigitalPageState();
  }
}

class _BilleteraDigitalPageState extends State<BilleteraDigitalPage> {
  TarjetaService tarjetaService = TarjetaService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _codigoAprobacion = TextEditingController();
  var loading = false;
  var _hasError = false;
  var _phoneNumber = "";

  void _submit() async {
    setState(() {
      loading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      try {
        bool? response = await tarjetaService.setRecarga(widget.montoARecargar, "yape");
        // pago

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const PaymentDialog();
            });
      } catch (e) {
        // Si la autenticación falla, muestra un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de autenticación: $e')),
        );
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 35,
          ),
          color: Colors.white,
        ),
        backgroundColor: const Color(0XFF405f90),
        title: const Text(
          "Recarga con Yape",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 40,
          horizontal: 50,
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/yape.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Número de celular',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _phoneNumber = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 9) {
                        return 'Ingrese un número de celular válido';
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Text(
                      'Código de aprobación',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  PinCodeTextField(
                    cursorColor: Colors.grey,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.scale,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        inactiveColor: Colors.grey,
                        activeColor: Colors.lightGreen),
                    appContext: context,
                    length: 6,
                    controller: _codigoAprobacion,
                    errorTextSpace: _hasError ? 20 : 0,
                    validator: (value) {
                      if (value == null || value.length != 6) {
                        Future.delayed(Duration.zero, () async {
                          setState(() {
                            _hasError = true;
                          });
                        });

                        return "Ingrese un código válido";
                      }
                      Future.delayed(Duration.zero, () async {
                        setState(() {
                          _hasError = false;
                        });
                      });
                      return null;
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                fixedSize: const Size(300, 60),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _submit,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Realizar pago",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "S/.${widget.montoARecargar}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
