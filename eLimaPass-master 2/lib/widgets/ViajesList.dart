import 'package:flutter/material.dart';

import '../models/entities/Viaje.dart';
import 'ViajeItem.dart';

class ViajesList extends StatelessWidget {
  final List<Viaje> viajes;

  const ViajesList({super.key, required this.viajes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viajes.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const Divider(
              height: 30,
            ),
            ViajeItem(viaje: viajes[index])
          ],
        );
      },
    );
  }
}
