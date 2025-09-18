import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:m3ngon/Pages/onboardingPage.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  get splash => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: LottieBuilder.asset("images/animation.json"),
      ),
      nextScreen: const OnboardingScreenPage(),
      splashIconSize: 400,
    );
  }
}
