mixin Validators {
  String? validatePassword(String? value) {
    if (value == null || value.trim().length < 8) {
      return 'Ingrese una contraseña válida';
    }
    return null;
  }

  String? validateEmail(String? value) {
    // Expresión regular para validar un email con dominio
    final emailRegex = RegExp(r'^[\w.-]+@[a-zA-Z\d-]+\.[a-zA-Z]{2,}$');

    if (value == null || !emailRegex.hasMatch(value.trim())) {
      return 'Ingrese un correo válido';
    }
    return null;
  }

  String? validateDni(String? value) {
    if (value == null ||
        value.trim().length != 8 ||
        !value.trim().contains(RegExp(r'^[0-9]{8}'))) {
      return 'Ingrese un DNI válido';
    }
    return null;
  }

  String? validateName(String? value) {
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');

    if (value == null || !nameRegex.hasMatch(value.trim())) {
      return "Ingrese un nombre válido";
    }
    return null;
  }
}
