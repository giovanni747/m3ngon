import 'package:flutter/material.dart';
//import 'package:m3ngon/Pages/accountPage.dart';
import 'package:m3ngon/Pages/intro_screens/intro_page1.dart';
import 'package:m3ngon/Pages/intro_screens/intro_page2.dart';
import 'package:m3ngon/Pages/intro_screens/intro_page3.dart';
import 'package:m3ngon/Pages/chosingSign.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreenPage extends StatefulWidget {
  const OnboardingScreenPage({super.key});

  @override
  State<OnboardingScreenPage> createState() => _OnboardingScreenPageState();
}

class _OnboardingScreenPageState extends State<OnboardingScreenPage> {
  // controller keeps track of which page we are on
  PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
              alignment: Alignment(0, 0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // skip
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text('skip'),
                  ),

                  // dot indicator
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const JumpingDotEffect(
                      activeDotColor: Colors.black,
                      dotColor: Color.fromARGB(10, 0, 0, 0),
                      dotHeight: 16,
                      dotWidth: 16,
                      spacing: 13,
                      jumpScale: 3,
                    ),
                  ),

                  // next or done
                  onLastPage
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChosingPage();
                                },
                              ),
                            );
                          },
                          child: Text('done'),
                        )
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Text('next'),
                        ),
                ],
              )),
        ],
      ),
    );
  }
}
