import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:m3ngon/Pages/Home.dart';

import 'package:m3ngon/components/textfieldLogin.dart';
import 'dart:math' as math;

import 'package:m3ngon/helper/helper_functions.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  // controller
  late final AnimationController _controller;
  late final AnimationController _controllerEye;
  late final AnimationController _controllerCON;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controllerEye = AnimationController(
        duration: const Duration(milliseconds: 20), vsync: this);
    _controllerCON =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
  }

  @override
  void dispose() {
    // Check if the controllers are still animating and stop them if they are.
    if (_controller.isAnimating) {
      _controller.stop();
    }
    if (_controllerEye.isAnimating) {
      _controllerEye.stop();
    }
    if (_controllerCON.isAnimating) {
      _controllerCON.stop();
    }

    // Now dispose the animation controllers.
    _controller.dispose();
    _controllerEye.dispose();
    _controllerCON.dispose();

    // Always call super.dispose() at the end of dispose method.
    super.dispose();
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final userController = TextEditingController();
  bool bookmarked = false;

  bool obscurePassword = true;
  bool obscureConfirmedPassword = true;

  Future<void> handleUserRegistration() async {
    if (!bookmarked) {
      setState(() {
        bookmarked = true;
      });

      await _controller.forward();
      await Future.delayed(const Duration(seconds: 1));

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false, // Prevent dialog from closing on tap outside
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      if (passwordController.text != confirmController.text) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        displayMessageToUser("Passwords don't match", context);
        _controller.reverse();
        bookmarked = false;
      } else {
        try {
          // ignore: unused_local_variable
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);
          if (context.mounted) {
            Navigator.pop(context);
          }
          // create a user document and add to firestore
          await userCredential.user?.reload();
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            // Successfully created a user account, now create a Firestore document.
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'email': user.email,
              'username': userController.text,
              // Assuming you want to store the email.
              // 'profilePicture': '',
              // Initialize with an empty string for the profile picture.
              'createdAt': FieldValue.serverTimestamp(),

              'followers': 0,
              'following': 0,
              'favorite_mangas': [],
              'mangaList': [],
              'following_users': [],
              'likeAmout': 0,
              // Record the time of creation.
            });
          }
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const HomePage(), // Assuming HomePage is a StatelessWidget
            ),
          );
        } on FirebaseAuthException catch (e) {
          Navigator.pop(context); // Dismiss the CircularProgressIndicator
          _controller.reverse();
          bookmarked = false;
          displayMessageToUser(e.code, context);
        } catch (error) {
          Navigator.pop(context);
          displayMessageToUser("An unexpected error occurred", context);
          _controller.reverse();
          bookmarked = false;
        }
        _controller.reverse();
        bookmarked = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(254, 250, 224, 1.0),
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
              height: 550,
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
                  const SizedBox(height: 20),
                  TextfieldLogin(
                    type: "username",
                    controller: userController,
                    obscureText: false,
                    controllerAnim: _controllerEye,
                    onTapVisibility: () {},
                  ),
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
                  TextfieldLogin(
                    type: "confirm password",
                    controller: confirmController,
                    obscureText:
                        obscureConfirmedPassword, // Pass the boolean to manage the visibility
                    controllerAnim: _controllerCON,

                    onTapVisibility: () {
                      // Callback function to toggle password visibility
                      setState(() {
                        obscureConfirmedPassword = !obscureConfirmedPassword;
                        if (obscureConfirmedPassword) {
                          _controllerCON.reverse();
                        } else {
                          _controllerCON.forward();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      handleUserRegistration();
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
