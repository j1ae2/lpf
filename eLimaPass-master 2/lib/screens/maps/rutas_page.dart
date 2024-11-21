import 'package:elimapass/services/map_service.dart';
import 'package:elimapass/widgets/RutaList.dart';
import 'package:flutter/material.dart';

import '../../models/entities/Ruta.dart';
import '../../models/responses/RutaResponse.dart';

class RutasPage extends StatefulWidget {
  const RutasPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RutasPageState();
  }
}

class _RutasPageState extends State<RutasPage> {
  MapService mapService = MapService();
  Map<String, List<Ruta>> rutasAgrupadas = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRutas();
  }

  void loadRutas() async {
    RutaResponse _rutas = await mapService.getRutas();
    setState(() {
      rutasAgrupadas = _rutas.rutasPorServicio;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : RutaList(rutasPorServicio: rutasAgrupadas),
      ),
    );
  }
}
