import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:sheride/views/on_board_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer for 5 seconds
    Timer(
      Duration(seconds: 5), // Wait for 5 seconds
      () {
        // Navigate to OnBoardingScreen with fade transition
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return OnBoardingScreen();
            },
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              // Apply FadeTransition
              const begin = 0.0;
              const end = 1.0;
              const curve = Curves.easeInOut;

              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              var opacity = animation.drive(tween);

              return FadeTransition(opacity: opacity, child: child);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Image.asset(
              "assets/images/logo.png", // Logo
              height: 150, // Height of Logo
              width: 150, // Width of Logo
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 25,
            ), // Add some space between the logo and the spinner
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.black,
              ), // Set the spinner color
            ),
          ],
        ),
      ),
    );
  }
}
