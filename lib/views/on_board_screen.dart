import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sheride/components/image_container_on_board_screen.dart';
import 'package:sheride/views/auth/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<OnBoardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    // listener to update `isLastPage` when page changes
    controller.addListener(() {
      if (controller.page == 2) {
        // 2 is the index of the last page (third page)
        setState(() {
          isLastPage = true;
        });
      } else {
        setState(() {
          isLastPage = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSize =
        screenWidth * 0.05; // Adjust font size based on screen width

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          bottom: screenHeight * 0.05,
        ), // Adjust bottom padding dynamically
        child: PageView(
          controller: controller,
          children: [
            // 1st Page
            buildImageContainer(
              Colors.white,
              "Explore New Trial",
              "Welcome to She Ride, your safe and reliable ride with trusted female drivers.",
              "assets/images/image1.jpg",
            ),
            // 2nd Page
            buildImageContainer(
              Colors.white,
              "Empowered Rides",
              "Feel confident and secure on every trip, with a network dedicated to women, by women.",
              "assets/images/image2.jpg",
            ),
            // 3rd Page
            Container(
              color: Colors.white,
              child: Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/images/taxibg.jpg",
                  height: screenHeight * 0.6, // Adjust image height dynamically
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet:
          isLastPage
              ? ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    screenWidth * 0.08,
                  ), // Adjust border radius dynamically
                  topRight: Radius.circular(screenWidth * 0.08),
                ),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    top:
                        screenHeight *
                        0.1, // Reduced top padding to make space for the title
                    left: screenWidth * 0.2,
                    right: screenWidth * 0.2,
                    bottom: screenHeight * 0.05,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Add the "She Taxi" text with two colors
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.khand(
                            fontSize: screenWidth * 0.2, // Dynamic font size
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: "She ",
                              style: TextStyle(color: Colors.pinkAccent),
                            ),
                            TextSpan(
                              text: "Taxi",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ), // Adjust spacing dynamically
                      Text(
                        "Your Safety - Our Priority",
                        style: GoogleFonts.khand(
                          fontSize:
                              screenWidth *
                              0.05, // Adjust font size dynamically
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.08), // Add more spacing
                      TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.03,
                            ), // Adjust border radius dynamically
                          ),
                          backgroundColor: Colors.pinkAccent,
                          minimumSize: Size(
                            screenWidth * 0.8,
                            screenHeight * 0.08,
                          ), // Dynamic button size
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                    ],
                  ),
                ),
              )
              : Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,
                ), // Adjust padding dynamically
                height: screenHeight * 0.06, // Dynamic height
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Button for skip
                    TextButton(
                      onPressed: () {
                        controller.jumpToPage(2); // Jump to Last Page
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05, // Dynamic font size
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                    // Smooth Page Indicator
                    Center(
                      child: SmoothPageIndicator(
                        effect: WormEffect(
                          spacing:
                              screenWidth *
                              0.04, // Dynamic spacing between dots
                          dotColor: Colors.pink.shade500,
                          activeDotColor: Colors.pink.shade200,
                        ),
                        onDotClicked: (index) {
                          controller.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                          );
                        },
                        controller: controller,
                        count: 3,
                      ),
                    ),
                    // Button for Next
                    TextButton(
                      onPressed: () {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05, // Dynamic font size
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
