import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 237, 201, 1.0),
      body: Stack(
        children: [
          Center(
            child:
                Lottie.asset("images/cat&girl.json", width: 400, height: 400),
          ),
          const Positioned(
            top: 610,
            left: 70,
            child: Text(
              "E X P L O R E  Y O U R  F A V ' S",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
