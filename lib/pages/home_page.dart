import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:welllog/pages/account_page.dart';
import 'package:welllog/pages/score_page.dart';
import 'package:welllog/pages/todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 1; // Orta sayfa (todo) default açılsın

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [ScorePage(), TodoPage(), AccountPage()],
      ),

      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Colors.transparent,
        color: Colors.green.shade600,
        buttonBackgroundColor: Colors.green.shade700,
        height: 60,
        animationDuration: const Duration(milliseconds: 300),

        items: const [
          Icon(Icons.show_chart, color: Colors.white, size: 28),
          Icon(Icons.list_alt, color: Colors.white, size: 28),
          Icon(Icons.person, color: Colors.white, size: 28),
        ],

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
