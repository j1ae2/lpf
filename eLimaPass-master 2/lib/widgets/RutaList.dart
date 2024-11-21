import 'package:flutter/material.dart';

import '../models/entities/Ruta.dart';
import 'RutaItem.dart';

class RutaList extends StatefulWidget {
  final Map<String, List<Ruta>> rutasPorServicio;

  const RutaList({super.key, required this.rutasPorServicio});

  @override
  _RutaListState createState() => _RutaListState();
}

class _RutaListState extends State<RutaList> {
  // Estado para almacenar qué categorías están ocultas o visibles
  Map<String, bool> _isExpanded = {};

  @override
  void initState() {
    super.initState();
    // Inicializar todas las categorías como visibles
    _isExpanded =
        widget.rutasPorServicio.map((key, value) => MapEntry(key, true));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.rutasPorServicio.keys.map((servicio) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            // Título del servicio con botón de expandir/colapsar (todo el contenedor es clickable)
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded[servicio] = !_isExpanded[servicio]!;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      servicio,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Icon(
                      _isExpanded[servicio]!
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ),
            // Animación de mostrar/ocultar rutas
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstChild: Container(),
              secondChild: Column(
                children: widget.rutasPorServicio[servicio]!
                    .map((ruta) => RutaItem(
                          ruta: ruta,
                          servicio: servicio,
                        ))
                    .toList(),
              ),
              crossFadeState: _isExpanded[servicio]!
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            const Divider(
              height: 20,
            )
          ],
        );
      }).toList(),
    );
  }
}
