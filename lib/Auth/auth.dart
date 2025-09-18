import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m3ngon/Pages/Home.dart';
import 'package:m3ngon/Pages/LoginPage.dart';
import 'package:m3ngon/Pages/splash.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        // Subscribe to user changes
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoginPage();
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            print("its working");
            return const HomePage();
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }
}
