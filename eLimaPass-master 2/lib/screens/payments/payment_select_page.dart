import 'package:elimapass/screens/historial_recargas_page.dart';
import 'package:elimapass/screens/payments/billetera_digital_page.dart';
import 'package:elimapass/screens/payments/tarjeta_creditdebit_page.dart';
import 'package:flutter/material.dart';

class PaymentSelectPage extends StatefulWidget {
  const PaymentSelectPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PaymentSelectPageState();
  }
}

class _PaymentSelectPageState extends State<PaymentSelectPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montoAPagar = TextEditingController();
  int _selectedPaymentMethod = -1;

  void _selectMethod(int method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  Future<void> onSubmit() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (_formKey.currentState!.validate()) {
      var monto = double.parse(_montoAPagar.text);
      _formKey.currentState!.save();
      _nextStep(monto);
    }
  }

  void _nextStep(double monto) {
    switch (_selectedPaymentMethod) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => CreditDebitPage(montoARecargar: monto),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => BilleteraDigitalPage(montoARecargar: monto),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Elija un medio de pago'),
        ));
        break;
    }
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
            "Opciones de recarga",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const SizedBox(
                        height: 400,
                        child: HistorialRecargasPage(),
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.history,
                  color: Theme.of(context).colorScheme.onSurface,
                ))
          ],
        ),
        body: Stack(
          children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        "Indica el monto a recargar",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*SizedBox(
                          width: 100,
                          child:
                        ),*/
                              _recargaSetter(10),
                              _recargaSetter(25),
                              _recargaSetter(50),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: SizedBox(
                                  width: 80,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    controller: _montoAPagar,
                                    decoration: InputDecoration(
                                      errorStyle: const TextStyle(
                                        color: Colors.transparent,
                                        fontSize: 0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                            width: 1.5,
                                            style: BorderStyle.solid,
                                            color: Colors.red),
                                      ),
                                      hintText: 'Monto',
                                      hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: const Color(0xff111318)
                                            .withOpacity(0.3),
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
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content:
                                              Text('Indique un monto válido'),
                                        ));
                                        return "Monto invalido";
                                      }
                                      if (int.tryParse(value) == null) {
                                        return "Inválido";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )),
                      const Divider(
                        thickness: 2,
                        height: 40,
                      ),
                      const Text(
                        "Elige tu medio de pago",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _gestureOption(0, 'Tarjeta', Icons.credit_card),
                          _gestureOption(1, 'Yape', Icons.phone_android),
                          // Botón para Tarjetas
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          fixedSize: const Size(250, 60),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: onSubmit,
                        child: const Text(
                          "Siguiente paso",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }

  Widget _recargaSetter(int amount) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          foregroundColor: Theme.of(context).colorScheme.onSecondary,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          fixedSize: const Size(80, 50)),
      onPressed: () {
        _montoAPagar.text = amount.toString();
      },
      child: Text(
        "S/. ${amount.toString()}",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _gestureOption(int option, String name, IconData icon) {
    return GestureDetector(
      onTap: () {
        _selectMethod(option);
      },
      child: Container(
        width: 150,
        height: 120,
        decoration: BoxDecoration(
          color: _setBgColor(option),
          border: Border.all(
            color: _setColor(option),
            width: _setBorderWidth(option),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: _setColor(option), size: 50),
            const SizedBox(height: 5),
            Text(
              name,
              style: TextStyle(
                  fontSize: 16,
                  color: _setColor(option),
                  fontWeight: _setWeight(option)),
            ),
          ],
        ),
      ),
    );
  }

  Color _setColor(option) {
    return _selectedPaymentMethod == option
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.6);
  }

  Color _setBgColor(option) {
    return _selectedPaymentMethod == option
        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
        : Theme.of(context).colorScheme.onSurface.withOpacity(0.1);
  }

  FontWeight _setWeight(option) {
    return _selectedPaymentMethod == option ? FontWeight.w800 : FontWeight.w400;
  }

  double _setBorderWidth(option) {
    return _selectedPaymentMethod == option ? 3 : 1;
  }
}
