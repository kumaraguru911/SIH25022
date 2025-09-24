import 'dart:async';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class TitlePage extends StatefulWidget {
  @override
  _TitlePageState createState() => _TitlePageState();
}

class _TitlePageState extends State<TitlePage> with TickerProviderStateMixin {
  int _currentImageIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  final List<String> _images = [
    "assets/indian_railways_bg.jpg",
    "assets/indian_railways_bg2.jpg",
    "assets/indian_railways_bg3.jpg",
    "assets/indian_railways_bg4.jpg",
    "assets/indian_railways_bg5.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    // Smoother, faster transition and less likely to hang
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (!mounted) return;
      if (_currentImageIndex < _images.length - 1) {
        _currentImageIndex++;
      } else {
        _currentImageIndex = 0;
      }
      _pageController.animateToPage(
        _currentImageIndex,
        duration: Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.of(context).push(_createRoute());
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => DashboardPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Button pop + screen fade
        return ScaleTransition(
          scale: Tween<double>(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Slideshow Background
          PageView.builder(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),

          // Overlay gradient for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.4),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Custom image with subtle white-blue glow
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.4),
                        blurRadius: 35,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(25),
                  child: Image.asset(
                    'assets/title_page_img.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 30),

                Text(
                  'AI-Powered Decision Support System',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),

                Text(
                  'For Indian Railway Train Traffic Controllers',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 60),

                ElevatedButton(
                  onPressed: () => _navigateToDashboard(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 12,
                  ),
                  child: Text(
                    'Enter Dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 50),

                Text(
                  'Designed by Hackitects for Indian Railways',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
