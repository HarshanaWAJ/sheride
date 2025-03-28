import 'package:flutter/material.dart';

Widget buildImageContainer(
  Color color,
  String title,
  String description,
  String imagePath,
) {
  return LayoutBuilder(
    builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;

      // Responsive font size based on screen width
      double titleFontSize = width * 0.08; // Title size is 8% of screen width
      double descriptionFontSize =
          width * 0.05; // Description size is 5% of screen width
      double padding = width * 0.1; // Padding is 10% of screen width

      return Container(
        color: color,
        child: Column(
          children: [
            SizedBox(height: height * 0.05), // 5% of screen height
            // Image
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: height * 0.4, // Image takes 40% of screen height
            ),

            // 1st Sized Box
            SizedBox(height: height * 0.05), // 5% of screen height
            // Title
            Text(
              title,
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),

            // 2nd Sized Box
            SizedBox(height: height * 0.02), // 2% of screen height
            // Description with TextAlign to center it
            Container(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Text(
                description,
                textAlign: TextAlign.center, // Centering the text
                style: TextStyle(
                  color: Colors.black,
                  fontSize: descriptionFontSize,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
