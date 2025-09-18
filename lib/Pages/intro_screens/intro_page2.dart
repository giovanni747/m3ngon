import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(120, 192, 224, 1.0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(height: 117),

          Center(
            child: Lottie.network(
                "https://lottie.host/14296cef-97fa-4ab9-ac46-a86e464503f7/nQ6HwxY9es.json",
                width: 400,
                height: 380),
          ),
          const SizedBox(height: 10),
          const Text(
            "S T A Y  C O N N E C T E D",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
