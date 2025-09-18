import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:lottie/lottie.dart';

class TextfieldLogin extends StatefulWidget {
  final String type;
  final TextEditingController controller;
  final bool obscureText;
  final AnimationController controllerAnim;
  final VoidCallback onTapVisibility; // Define the callback here

  const TextfieldLogin({
    Key? key,
    required this.type,
    required this.controller,
    this.obscureText = true, // Default value for obscureText
    required this.controllerAnim,
    required this.onTapVisibility, // Pass the callback here
  }) : super(key: key);

  @override
  State<TextfieldLogin> createState() => _TextfieldLoginState();
}

class _TextfieldLoginState extends State<TextfieldLogin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        style: const TextStyle(
          color: Color.fromRGBO(214, 29, 77, 1.0),
          fontWeight: FontWeight.w700,
        ),
        cursorWidth: 5,
        cursorHeight: 15,
        cursorColor: const Color.fromARGB(255, 171, 67, 30),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(254, 250, 224, 1.0)),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(254, 250, 224, 1.0)),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: const Color.fromRGBO(233, 237, 201, 1.0),
          filled: true,
          hintText: widget.type,
          hintStyle: const TextStyle(
            color: Color.fromRGBO(204, 213, 174, 1.0),
          ),
          suffixIcon: widget.type.toLowerCase() == "password" ||
                  widget.type.toLowerCase() == "confirm password"
              ? GestureDetector(
                  onTap: widget.onTapVisibility, // Invoke the callback here
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: LottieBuilder.asset(
                        "images/eyes.json",
                        controller: widget.controllerAnim,
                        onLoaded: (composition) {
                          widget.controllerAnim.duration = composition.duration;
                        },
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
