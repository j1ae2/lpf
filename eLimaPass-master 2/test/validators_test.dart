import 'package:elimapass/util/validators.dart';
import 'package:flutter_test/flutter_test.dart';

class ValidatorsMixinClass with Validators {}

void main() {
  late ValidatorsMixinClass validators;

  setUp(() {
    validators = ValidatorsMixinClass();
  });

  group('Testeando validación de contraseña', () {
    test('Contraseña null', () {
      String? rsp = validators.validatePassword(null);
      expect(rsp, "Ingrese una contraseña válida");
    });

    test("Contraseña corta", () {
      String? rsp = validators.validatePassword("abcd");
      expect(rsp, "Ingrese una contraseña válida");
    });

    test("Contraseña corta con espacios", () {
      String? rsp = validators.validatePassword("  abcd  ");
      expect(rsp, "Ingrese una contraseña válida");
    });

    test("Contraseña de 8+ caracteres", () {
      String? rsp = validators.validatePassword("abcdefgh");
      expect(rsp, null);
    });
  });

  group('Testeando validación de DNI', () {
    test('DNI null', () {
      String? rsp = validators.validateDni(null);
      expect(rsp, "Ingrese un DNI válido");
    });

    test("DNI corto", () {
      String? rsp = validators.validateDni("1234");
      expect(rsp, "Ingrese un DNI válido");
    });

    test("DBI largo", () {
      String? rsp = validators.validateDni("1234567890");
      expect(rsp, "Ingrese un DNI válido");
    });

    test("DNI de 8 caracteres pero con letras", () {
      String? rsp = validators.validateDni("ABCABCAB");
      expect(rsp, "Ingrese un DNI válido");
    });

    test("DNI de 8 caracteres alfanumerico", () {
      String? rsp = validators.validateDni("123ABC12");
      expect(rsp, "Ingrese un DNI válido");
    });

    test("DNI de 8 numeros con espacio", () {
      String? rsp = validators.validateDni("  12345678 ");
      expect(rsp, null);
    });

    test("DNI de 8 numeros", () {
      String? rsp = validators.validateDni("75995741");
      expect(rsp, null);
    });
  });

  group('Testeando validación de correo electrónico', () {
    test('Email null', () {
      String? rsp = validators.validateEmail(null);
      expect(rsp, "Ingrese un correo válido");
    });

    test("Email sin '@'", () {
      String? rsp = validators.validateEmail("testemail.com");
      expect(rsp, "Ingrese un correo válido");
    });

    test("Email sin dominio", () {
      String? rsp = validators.validateEmail("test@");
      expect(rsp, "Ingrese un correo válido");
    });

    test("Email válido", () {
      String? rsp = validators.validateEmail("test@example.com");
      expect(rsp, null);
    });

    test("Email con espacios al inicio y al final", () {
      String? rsp = validators.validateEmail("  test@example.com  ");
      expect(rsp, null);
    });
  });

  group('Testeando validación de nombre', () {
    test('Nombre null', () {
      String? rsp = validators.validateName(null);
      expect(rsp, "Ingrese un nombre válido");
    });

    test("Nombre vacío", () {
      String? rsp = validators.validateName(" ");
      expect(rsp, "Ingrese un nombre válido");
    });

    test("Nombre con números", () {
      String? rsp = validators.validateName("John123");
      expect(rsp, "Ingrese un nombre válido");
    });

    test("Nombre con caracteres especiales", () {
      String? rsp = validators.validateName("John@Doe");
      expect(rsp, "Ingrese un nombre válido");
    });

    test("Nombre solo con letras", () {
      String? rsp = validators.validateName("Juan");
      expect(rsp, null);
    });

    test("Nombre con letras y espacios", () {
      String? rsp = validators.validateName("Juan Carlos");
      expect(rsp, null);
    });
  });
}
