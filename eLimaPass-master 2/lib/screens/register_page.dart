import 'package:elimapass/screens/login.dart';
import 'package:elimapass/services/RegisterService.dart';
import 'package:elimapass/util/validators.dart';
import 'package:flutter/material.dart';

import '../widgets/car_background.dart';
import '../widgets/loading_foreground.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> with Validators {
  var _dni = "";
  var _nombres = "";
  var _apellidos = "";
  var _email = "";
  var _password = "";
  var _tarjeta = "";

  final _registerService = RegisterService();
  bool loading = false;
  bool success = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  void _submit() async {
    setState(() {
      loading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        await _registerService.register(
            _dni, _email, _nombres, _apellidos, _password, _tarjeta);
        // Si la autenticación es exitosa, navega a la pantalla de login
        setState(() {
          success = true;
        });
      } catch (e) {
        // Si la autenticación falla, muestra un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error de registro: $e')),
        );
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const CarBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image(
                        image: const AssetImage(
                          'assets/logo.png',
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      _textFields(),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff111318),
                          foregroundColor: const Color(0XFFFFFFFF),
                          fixedSize: const Size(300, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _submit,
                        child: const Text(
                          "Registrarme",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("¿Ya estás registrado?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13)),
                          const SizedBox(
                            width: 6,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text("¡Inicia sesión aquí!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    color: Colors.white,
                                  )))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (loading) const LoadingForeground(),
          if (success)
            AlertDialog(
              title: const Text("Registro exitoso"),
              content: const Text(
                "Presione el botón para iniciar sesión",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (ctx) => const LoginScreen(),
                        ),
                        (Route<dynamic> route) => false);
                  },
                  child: const Text("Ir a inicio"),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _textFields() {
    return Column(children: [
      TextFormField(
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
          hintText: 'DNI',
          hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: const Color(0xff111318).withOpacity(0.3)),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xff111318),
        ),
        validator: (value) => validateDni(value),
        onSaved: (value) {
          _dni = value!;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Color(0xffffb4ab)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: 'Correo electrónico',
          hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: const Color(0xff111318).withOpacity(0.3)),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xff111318),
        ),
        validator: (value) => validateEmail(value),
        onSaved: (value) {
          _email = value!;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Color(0xffffb4ab)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: 'Nombres',
          hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: const Color(0xff111318).withOpacity(0.3)),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xff111318),
        ),
        onSaved: (value) {
          _nombres = value!;
        },
        validator: (value) => validateName(value),
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Color(0xffffb4ab)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: 'Apellidos',
          hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: const Color(0xff111318).withOpacity(0.3)),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xff111318),
        ),
        onSaved: (value) {
          _apellidos = value!;
        },
        validator: (value) => validateName(value),
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: passController,
        obscureText: true,
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Color(0xffffb4ab)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: 'Contraseña',
          hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: const Color(0xff111318).withOpacity(0.3)),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xff111318),
        ),
        validator: (value) => validatePassword(value),
        onSaved: (value) {
          _password = value!;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
        controller: confirmPassController,
        obscureText: true,
        decoration: InputDecoration(
          errorStyle: const TextStyle(color: Color(0xffffb4ab)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          hintText: 'Confirme su contraseña',
          hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: const Color(0xff111318).withOpacity(0.3)),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xff111318),
        ),
        validator: (value) {
          if (passController.text != confirmPassController.text) {
            return "Las contraseñas no coinciden";
          }
          return null;
        },
      ),
      const SizedBox(
        height: 10,
      ),
      TextFormField(
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
          hintText: 'Afilie su tarjeta existente (opcional)',
          hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: const Color(0xff111318).withOpacity(0.3)),
          filled: true,
          fillColor: Colors.white,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xff111318),
        ),
        validator: (value) {
          if (value!.isEmpty || value.length == 10) {
            return null;
          }
          return "La tarjeta ingresada no es válida";
        },
        onSaved: (value) {
          _tarjeta = value!;
        },
      )
    ]);
  }
}
