import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:m3ngon/Pages/Home.dart';
import 'package:m3ngon/components/textfieldLogin.dart';
import 'package:m3ngon/helper/helper_functions.dart';
import 'dart:math' as math;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  // controller
  late final AnimationController _controller;
  late final AnimationController _controllerEye;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controllerEye = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controllerEye.dispose();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool bookmarked = false;

  bool obscurePassword = true;

  Future<void> login() async {
    if (!bookmarked) {
      setState(() {
        bookmarked = true;
      });
      await _controller.forward();
      await Future.delayed(const Duration(seconds: 1));
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dialog from closing on tap outside
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        if (context.mounted) {
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
        _controller.reverse();
        bookmarked = false;
      } catch (error) {
        Navigator.pop(context);
        displayMessageToUser("An unexpected error occurred", context);
        _controller.reverse();
        bookmarked = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 250, 224, 1.0),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            child: LottieBuilder.asset(
              "images/backgroundM.json",
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Transform(
              transform: Matrix4.rotationY(math.pi),
              alignment: Alignment.center,
              child: LottieBuilder.asset(
                "images/backgroundM.json",
              ),
            ),
          ),
          Center(
            child: Container(
              width: 350,
              height: 500,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(254, 250, 224, 1.0),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 160, 153, 153),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("M 3 N G O N ",
                      style: TextStyle(
                        color: Color.fromRGBO(204, 213, 174, 1.0),
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      )),
                  const SizedBox(height: 40),
                  TextfieldLogin(
                    type: "email",
                    controller: emailController,
                    obscureText: false,
                    controllerAnim: _controllerEye,
                    onTapVisibility: () {},
                  ),
                  TextfieldLogin(
                    type: "password",
                    controller: passwordController,
                    obscureText:
                        obscurePassword, // Pass the boolean to manage the visibility
                    controllerAnim: _controllerEye,

                    onTapVisibility: () {
                      // Callback function to toggle password visibility
                      setState(() {
                        obscurePassword = !obscurePassword;
                        if (obscurePassword) {
                          _controllerEye.reverse();
                        } else {
                          _controllerEye.forward();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      login();
                    },
                    child: LottieBuilder.asset(
                      "images/submit.json",
                      controller: _controller,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
