import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoaderScreen extends StatelessWidget {
  const LoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset("images/loading.json"),
    );
  }
}
