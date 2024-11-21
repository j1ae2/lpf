import 'package:flutter/material.dart';

class CarBackground extends StatelessWidget {
  const CarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: Image(
            image: AssetImage('assets/home.jpeg'),
            fit: BoxFit.cover, // Ensures the image covers the whole screen
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0XFF08305f).withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}
