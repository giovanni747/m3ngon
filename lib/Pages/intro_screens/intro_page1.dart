import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5),
          Center(
            child: Lottie.network(
                "https://lottie.host/950abd43-5e0a-49f5-8f93-1c7a2929a1cd/a9dFQfm0QJ.json",
                width: 400,
                height: 389),
          ),
          const Text("G E T  R E C O M M E N D A T I O N S ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
