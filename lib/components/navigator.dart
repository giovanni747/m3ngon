import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';

class NavigatorBot extends StatefulWidget {
  final Function(int) onNavIndexChange;
  const NavigatorBot({Key? key, required this.onNavIndexChange})
      : super(key: key);

  @override
  State<NavigatorBot> createState() => _NavigatorBotState();
}

bool toggle = true;

class _NavigatorBotState extends State<NavigatorBot>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late final AnimationController _controllerPin;
  late final AnimationController _controllerBook;
  late final AnimationController _controllerAccount;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controllerPin =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controllerBook =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controllerAccount =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 350),
        reverseDuration: Duration(milliseconds: 500));
    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (_controllerPin.isAnimating) {
      _controllerPin.stop();
    }
    if (_controllerBook.isAnimating) {
      _controllerBook.stop();
    }
    if (_controllerAccount.isAnimating) {
      _controllerAccount.stop();
    }

    _controllerPin.dispose();
    _controllerBook.dispose();
    _controllerAccount.dispose();

    _controller.dispose();
    super.dispose();
  }

  Alignment alignment2 = Alignment(0.0, 0.0);
  Alignment alignment3 = Alignment(0.0, 0.0);
  Alignment alignment4 = Alignment(0.0, 0.0);

  double size2 = 100.0;
  double size3 = 100.0;
  double size4 = 100.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 300,
      width: 250,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AnimatedAlign(
            duration: toggle
                ? Duration(milliseconds: 275)
                : Duration(milliseconds: 875),
            alignment: alignment4,
            curve: toggle ? Curves.easeIn : Curves.elasticOut,
            child: GestureDetector(
              onTap: () {
                widget.onNavIndexChange(0);
                if (_controllerBook.status == AnimationStatus.completed) {
                  _controllerBook
                      .reverse(); // Reverse the animation when tapped again
                } else {
                  _controllerBook.forward(); // Start or continue the animation
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 275),
                curve: toggle ? Curves.easeIn : Curves.elasticOut,
                height: size4,
                width: size4,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: LottieBuilder.asset(
                  "images/bookEX.json",
                  controller: _controllerBook,
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: toggle
                ? Duration(milliseconds: 275)
                : Duration(milliseconds: 875),
            alignment: alignment2,
            curve: toggle ? Curves.easeIn : Curves.elasticOut,
            child: GestureDetector(
              onTap: () {
                widget.onNavIndexChange(1);
                if (_controllerAccount.status == AnimationStatus.completed) {
                  _controllerAccount
                      .reverse(); // Reverse the animation when tapped again
                } else {
                  _controllerAccount
                      .forward(); // Start or continue the animation
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 275),
                curve: toggle ? Curves.easeIn : Curves.elasticOut,
                height: size2,
                width: size2,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: LottieBuilder.asset(
                  "images/profile.json",
                  controller: _controllerAccount,
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: toggle
                ? Duration(milliseconds: 275)
                : Duration(milliseconds: 875),
            alignment: alignment3,
            curve: toggle ? Curves.easeIn : Curves.elasticOut,
            child: GestureDetector(
              onTap: () {
                widget.onNavIndexChange(2);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 275),
                curve: toggle ? Curves.easeIn : Curves.elasticOut,
                height: size3,
                width: size3,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: LottieBuilder.asset("images/firetrend.json"),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: _animation.value * pi * (3 / 4),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 600),
                curve: Curves.easeOut,
                width: toggle ? 80 : 70,
                height: toggle ? 80 : 70,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(120),
                  elevation: 20, // Set the elevation value as needed

                  child: IconButton(
                    splashColor: Colors.black,
                    splashRadius: 31.0,
                    onPressed: () {
                      setState(() {
                        if (toggle) {
                          toggle = !toggle;
                          _controller.forward();
                          _controllerPin.forward();

                          Future.delayed(Duration(milliseconds: 200), () {
                            alignment2 = Alignment(0.0, -0.7);
                            size2 = 90.0;
                          });
                          Future.delayed(Duration(milliseconds: 300), () {
                            alignment3 = Alignment(0.8, -0.2);
                            size3 = 90.0;
                          });
                          Future.delayed(Duration(milliseconds: 10), () {
                            alignment4 = Alignment(-0.8, -0.2);
                            size4 = 90.0;
                          });
                        } else {
                          toggle = !toggle;
                          _controllerPin.reverse();
                          _controller.reverse();

                          alignment2 = Alignment(0.0, 0.0);
                          alignment3 = Alignment(0.0, 0.0);
                          alignment4 = Alignment(0.0, 0.0);
                          size2 = size3 = size4 = 40;
                        }
                      });
                    },
                    icon: LottieBuilder.asset(
                      controller: _controllerPin,
                      "images/looked.json",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
