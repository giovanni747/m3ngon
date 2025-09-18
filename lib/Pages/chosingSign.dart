import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:m3ngon/Pages/SigninPage.dart';
import 'package:m3ngon/Pages/loginPage.dart';
import 'package:m3ngon/components/auth_Icons.dart';
// import 'package:m3ngon/components/glass_box.dart';

class ChosingPage extends StatelessWidget {
  const ChosingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(254, 250, 224, 1.0),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              child: Container(
                width: 410,
                height: 410,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LottieBuilder.asset(
                    "images/movingAnimation.json",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 185,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 39),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle Signup
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInPage()),
                            );
                          },
                          child: const Text(
                            "Signup",
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1.5,
                      color: Colors.black,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 13),
                          child: Text(
                            "If you already have an account ",
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 3),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                            // Handle Login
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 40,
              left: 0, // Set left to 0 to start from the left edge
              right: 0, // Set right to 0 to end at the right edge
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GAIcons(icons: "images/google.png"),
                  SizedBox(width: 23),
                  GAIcons(icons: "images/apple.png"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
