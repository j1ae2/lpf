import 'package:flutter/material.dart';

class LoadingForeground extends StatelessWidget {
  const LoadingForeground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black26,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ));
  }
}
