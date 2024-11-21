import 'package:elimapass/widgets/RecargaList.dart';
import 'package:flutter/material.dart';

import '../models/entities/Recarga.dart';
import '../services/tarjeta_service.dart';

class HistorialRecargasPage extends StatefulWidget {
  const HistorialRecargasPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HistorialRecargasPageState();
  }
}

class _HistorialRecargasPageState extends State<HistorialRecargasPage> {
  bool _loadingRecargas = false;
  List<Recarga> _recargas = [];
  TarjetaService tarjetaService = TarjetaService();

  void cargarRecargas() async {
    if (_loadingRecargas) return;
    if (!mounted) return;
    setState(() {
      _loadingRecargas = true;
    });

    try {
      List<Recarga> listaRecargas = await tarjetaService.getRecargas();
      if (!mounted) return;
      setState(() {
        _recargas = listaRecargas;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ha ocurrido un error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loadingRecargas = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    cargarRecargas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0XFF405f90),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: cargarRecargas,
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ],
          title: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              "Historial de recargas",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          )),
      body: _loadingRecargas
          ? const Padding(
              padding: EdgeInsets.all(50),
              child: Center(child: CircularProgressIndicator()),
            )
          : RecargasList(recargas: _recargas),
    );
  }
}
