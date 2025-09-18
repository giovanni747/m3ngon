import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {
  final TabController tabController;

  MyTabBar({
    Key? key,
    required this.tabController,
  });

  final _selectedColor = const Color.fromRGBO(239, 235, 205, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
      decoration: BoxDecoration(
        color: _selectedColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      child: TabBar(
        controller: tabController,
        indicator: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
          color: Color(0xFFA3A380),
        ),
        labelColor: const Color.fromRGBO(239, 235, 205, 1),
        unselectedLabelColor: const Color.fromRGBO(214, 206, 147, 1.0),
        tabs: [
          Tab(
            icon: Image.asset('images/heart.png'),
          ),
          Tab(
            icon: Image.asset('images/high-five.png'),
          ),
          Tab(
            icon: Image.asset('images/favorite.png'),
          ),
        ],
      ),
    );
  }
}
