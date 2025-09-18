import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class CardSelectPage extends StatefulWidget {
  CardSelectPage({super.key});

  @override
  State<CardSelectPage> createState() => _CardSelectPageState();
}

class _CardSelectPageState extends State<CardSelectPage> {
  final CardSwiperController controller = CardSwiperController();

  List<Container> cards = [
    Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blue,
      ),
      child: const Text('1'),
    ),
    Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.red,
      ),
      child: const Text('2'),
    ),
    Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.purple,
      ),
      child: const Text('3'),
    )
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    if (direction.name == "left") {
      print("I am left");
    } else {
      print("I am right");
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 250, 224, 1.0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 325,
              height: 486,
              child: Flexible(
                child: CardSwiper(
                  controller: controller,
                  onSwipe: _onSwipe,
                  allowedSwipeDirection:
                      const AllowedSwipeDirection.only(left: true, right: true),
                  cardsCount: cards.length,
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) =>
                          cards[index],
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
