import 'package:elimapass/screens/maps/map_page.dart';
import 'package:flutter/material.dart';

import '../models/entities/Ruta.dart';

class RutaItem extends StatelessWidget {
  final Ruta ruta;
  final String servicio;
  const RutaItem({super.key, required this.ruta, required this.servicio});

  @override
  Widget build(BuildContext context) {
    // Determinar el icono basado en el tipo de servicio
    IconData iconoServicio;
    if (servicio.toLowerCase().contains('corredor')) {
      iconoServicio = Icons.directions_bus;
    } else if (servicio.toLowerCase() == 'metropolitano') {
      iconoServicio = Icons.train;
    } else {
      iconoServicio = Icons.directions; // Icono genérico para otros servicios
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context)
                  .colorScheme
                  .inverseSurface
                  .withOpacity(0.15),
              blurRadius: 0,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => MapPage(
                  ruta: ruta,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icono basado en el tipo de servicio a la izquierda
                Icon(
                  iconoServicio,
                  color: Colors.blue,
                ),
                const SizedBox(
                    width: 12.0), // Espacio entre el icono y el texto
                // Nombre y detalles de la ruta
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre de la ruta con texto truncado si es muy largo
                      Text(
                        ruta.nombre,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                        overflow: TextOverflow.ellipsis, // Truncar con "..."
                        maxLines: 1, // Limitar a una línea
                      ),
                      Text(
                        '${ruta.inicio} - ${ruta.fin}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // Icono de mapa a la derecha
                Icon(
                  Icons.map,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
