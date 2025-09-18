import 'package:flutter/material.dart';
import 'package:show_up_animation/show_up_animation.dart';

class Square extends StatefulWidget {
  final String
      title; // allows for the info of the book to be passed into the container
  final String author;
  final String description; // book description
  final String image;
  final String user;
  final String image2;

  const Square(
      {required this.title,
      required this.author,
      required this.description,
      required this.image,
      required this.user,
      required this.image2});

  @override
  State<Square> createState() => _SquareState();
}

class _SquareState extends State<Square> {
  double uppos = 60.0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 11, bottom: 11),
      child: Stack(
        children: [
          Container(
            width: 400,
            height: 360,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade700,
                  blurRadius: 8,
                  offset: const Offset(14, 4),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      widget.image2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 27,
                      width: 250,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 17),
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20, // Adjust height as needed
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17),
                        child: Text(
                          widget.user,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 120, // Adjust position as needed
            left: 35, // Adjust position as needed
            child: Container(
              width: 330,
              height: 210,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 33, right: 30),
                child: SingleChildScrollView(
                    child: Text(
                  widget.description,
                  style: TextStyle(fontSize: 20),
                )),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 250,
            child: ShowUpAnimation(
              delayStart: const Duration(seconds: 1),
              animationDuration: const Duration(seconds: 1),
              curve: Curves.bounceIn,
              direction: Direction.vertical,
              offset: 0.5,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
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
