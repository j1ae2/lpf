import 'package:elimapass/screens/maps/rutas_page.dart';
import 'package:elimapass/services/notification_service.dart';
import 'package:elimapass/services/tarjeta_service.dart';
import 'package:flutter/material.dart';

import '../util/notifier.dart';
import 'alert_page.dart';
import 'home_page.dart';
import 'login.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AppHomeState();
  }
}

class _AppHomeState extends State<AppHome> {
  int _currPageIndex = 0;
  final TarjetaService _tarjetaService = TarjetaService();

  @override
  void initState() {
    super.initState();
    _checkSaldo();
  }

  Future<void> _checkSaldo() async {
    try {
      // Obtener el saldo mínimo guardado
      double? saldoMinimo = await _tarjetaService.provider.getSaldoMinimo();
      double saldoActual = await _tarjetaService.getSaldo();
      bool? hasBeenNotified = AppNotifier().notified;

      if (saldoMinimo == null || hasBeenNotified == null) return;
      // Obtener el saldo actual desde la API

      if (saldoActual < saldoMinimo && hasBeenNotified) {
        hasBeenNotified = true;
        // Mostrar la notificación
        showNotification("Saldo bajo",
            "El saldo de tu tarjeta es de S/. $saldoActual. ¡Recarga pronto!");
      }
    } catch (e) {
      debugPrint("Error al verificar el saldo: $e");
    }
  }

  final destinations = <Widget>[
    const NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Inicio',
    ),
    const NavigationDestination(
      icon: Icon(Icons.map_outlined),
      selectedIcon: Icon(Icons.map),
      label: 'Rutas',
    ),
  ];

  final appbarTitles = ["Mi eLimaPass", "Rutas y Paraderos"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0XFF405f90),
        title: Text(
          appbarTitles[_currPageIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        actions: [
          if (_currPageIndex == 0)
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return const SizedBox(
                        height: 400,
                        child: AlertPage(),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add_alert),
                color: Colors.white),
          IconButton(
              onPressed: () async {
                await _tarjetaService.provider.removeTarjeta();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) =>
                      false, // Elimina todas las rutas anteriores
                );
              },
              icon: const Icon(Icons.logout),
              color: Colors.white),
        ],
      ),
      body: <Widget>[const HomePage(), const RutasPage()][_currPageIndex],
      bottomNavigationBar: NavigationBar(
        height: 65,
        onDestinationSelected: (int index) {
          setState(() {
            _currPageIndex = index;
          });
        },
        selectedIndex: _currPageIndex,
        destinations: destinations,
      ),
    );
  }
}
