import 'package:flutter/material.dart';
import 'package:m3ngon/Pages/EPG.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:m3ngon/Pages/accountPage.dart';
import 'package:m3ngon/Pages/randomPage.dart';
import 'package:m3ngon/Pages/trending.dart';
import 'package:m3ngon/components/navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  Offset _navigatorOffset = Offset(0, 600); // Start with some offset
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _positionAnimation;

  final List<Widget> _pages = [
    ExplorePage(),
    accountPage(),
    TrendPage(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.6)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    _positionAnimation = Tween<Offset>(
            begin: _navigatorOffset,
            end: Offset(100, 100) // Just an example value
            )
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addListener(() {
      // Comment this out to test manual dragging without animation interference
      // setState(() {
      //   _navigatorOffset = _positionAnimation.value;
      // });
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // Obtain the screen size
    Size screenSize = MediaQuery.of(context).size;

    // Calculate new position with delta applied
    double newX = _navigatorOffset.dx + details.delta.dx;
    double newY = _navigatorOffset.dy + details.delta.dy;

    // Define a margin of 10 pixels from any screen edge
    const double margin = 10.0;

    // Calculate the maximum X and Y positions based on screen size and margin
    double maxX = screenSize.width - margin;
    double maxY = screenSize.height - margin;

    // Clamp the X and Y positions within the screen bounds with margin
    newX = newX.clamp(margin, maxX);
    newY = newY.clamp(margin, maxY);

    // Update state to move navigator
    setState(() {
      _navigatorOffset = Offset(newX, newY);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void _handleDragUpdate(DragUpdateDetails details) {
  //   // Obtain the screen size
  //   Size screenSize = MediaQuery.of(context).size;

  //   // Obtain the RenderBox and size for the navigator widget
  //   final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //   final Size navSize = renderBox.size;

  //   // Calculate new position with delta applied
  //   double newX = _navigatorOffset.dx + details.delta.dx;
  //   double newY = _navigatorOffset.dy + details.delta.dy;

  //   // Clamp the X and Y positions within the screen bounds
  //   newX = newX.clamp(0, screenSize.width - navSize.width);
  //   newY = newY.clamp(0, screenSize.height - navSize.height);

  //   // Debug output to check values
  //   print("Screen Size: $screenSize");
  //   print("Navigator Size: $navSize");
  //   print("New Position: ($newX, $newY)");

  //   // Update state to move navigator
  //   setState(() {
  //     _navigatorOffset = Offset(newX, newY);
  //   });
  // }

  void _handleDragEnd(DragEndDetails details) {
    // Prepare to animate back to the nearest valid position or other based on your logic
    final Offset finalPosition =
        _navigatorOffset; // Modify this based on your conditions

    _positionAnimation = Tween<Offset>(
      begin: _navigatorOffset,
      end: finalPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller
      ..reset()
      ..forward();
  }

  void _handleTap() {
    if (_controller.isCompleted) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            Positioned(
              left: _navigatorOffset.dx,
              top: _navigatorOffset.dy,
              child: GestureDetector(
                onPanUpdate: _handleDragUpdate,
                onPanEnd: _handleDragEnd,
                onTap: _handleTap,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: NavigatorBot(
                    onNavIndexChange: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
