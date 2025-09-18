import 'package:flutter/material.dart';

class GAIcons extends StatelessWidget {
  final String icons;
  const GAIcons({super.key, required this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(254, 250, 224, 1.0),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 183, 175, 175),
            offset: Offset(4, 5),
            blurRadius: 15,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Color.fromRGBO(254, 252, 239, 1),
            offset: Offset(-4, -5),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
          child: Image.asset(
        icons,
        width: 32,
      )),
    );
  }
}
