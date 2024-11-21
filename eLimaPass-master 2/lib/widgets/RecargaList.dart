import 'package:flutter/material.dart';

import '../models/entities/Recarga.dart';
import 'RecargaItem.dart';

class RecargasList extends StatelessWidget {
  final List<Recarga> recargas;

  const RecargasList({super.key, required this.recargas});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recargas.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const SizedBox(height: 20),
            RecargaItem(recarga: recargas[index]),
            const Divider(
              height: 30,
            ),
          ],
        );
      },
    );
  }
}
