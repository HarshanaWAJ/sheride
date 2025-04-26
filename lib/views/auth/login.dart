import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:logger/web.dart';
import 'package:sheride/views/auth/otp.dart';
import 'package:sheride/views/auth/register.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  Logger logger = Logger();

  final TextEditingController _mobile_number_controller =
      TextEditingController();
  PhoneNumber? _phoneNumber;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(2),
            child: Center(
              child: Column(
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: screenHeight * 0.15,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Text "She Ride"
                  Text(
                    "She Ride",
                    style: GoogleFonts.khand(
                      fontSize: screenWidth * 0.15,
                      fontWeight: FontWeight.w400,
                      shadows: [
                        Shadow(
                          offset: Offset(5.0, 5.0),
                          blurRadius: 5.0,
                          color: const Color.fromARGB(80, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Form Section
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        color: const Color.fromARGB(50, 233, 30, 98),
                        child: Column(
                          children: [
                            SizedBox(height: screenHeight * 0.05),
                            Text(
                              "Sign In",
                              style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.1,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05),
                            Container(
                              margin: EdgeInsets.only(left: 30, right: 30),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "We will send you a verification code to this number",
                                  style: GoogleFonts.roboto(
                                    fontSize: screenWidth * 0.03,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            // Single input field for Country Code and Phone Number together
                            Container(
                              margin: EdgeInsets.only(left: 30, right: 30),
                              child: IntlPhoneField(
                                controller: _mobile_number_controller,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelStyle: GoogleFonts.khand(
                                    color: const Color.fromARGB(100, 0, 0, 0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                initialCountryCode: 'LK',
                                onChanged: (phone) {
                                  _phoneNumber = phone;
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),

                            // Next Button
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                minimumSize: Size(
                                  screenWidth * 0.8,
                                  screenHeight * 0.06,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    screenWidth * 0.03,
                                  ),
                                ),
                              ),
                              // Function for Login Login
                              onPressed: () async {
                                try {
                                  if (_phoneNumber == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please enter a valid phone number",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  String completeNumber =
                                      _phoneNumber!.completeNumber;

                                  // Show loading indicator
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder:
                                        (context) => Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                  );

                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: completeNumber,
                                    verificationCompleted: (
                                      phoneAuthCredential,
                                    ) async {
                                      Navigator.pop(context); // Remove loading

                                      try {
                                        // Try to sign in with the credential
                                        // ignore: unused_local_variable
                                        UserCredential userCredential =
                                            await FirebaseAuth.instance
                                                .signInWithCredential(
                                                  phoneAuthCredential,
                                                );

                                        // If successful, user exists - proceed to OTP verification
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => OtpVerifyPage(
                                                  mobileNumber: completeNumber,
                                                  verificationId:
                                                      phoneAuthCredential
                                                          .verificationId ??
                                                      '',
                                                ),
                                          ),
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        // If user doesn't exist, navigate to registration
                                        if (e.code == 'user-not-found') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => RegisterPage(
                                                    mobileNumber:
                                                        completeNumber,
                                                  ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Error: ${e.message}",
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    verificationFailed: (error) {
                                      Navigator.pop(context); // Remove loading
                                      logger.e(
                                        "Verification Failed: ${error.message}",
                                      );
                                      String errorMessage =
                                          error.message ??
                                          'Verification failed';

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(errorMessage)),
                                      );
                                    },
                                    codeSent: (
                                      verificationId,
                                      forceResendingToken,
                                    ) {
                                      Navigator.pop(context); // Remove loading
                                      // For code sent, we assume the number might be registered
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => OtpVerifyPage(
                                                mobileNumber: completeNumber,
                                                verificationId: verificationId,
                                              ),
                                        ),
                                      );
                                    },
                                    codeAutoRetrievalTimeout: (verificationId) {
                                      Navigator.pop(context); // Remove loading
                                      logger.i("Auto retrieval timeout");
                                    },
                                    timeout: Duration(seconds: 60),
                                  );
                                } catch (e) {
                                  Navigator.pop(
                                    context,
                                  ); // Remove loading if still showing
                                  logger.e("Error in phone verification: $e");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "An error occurred. Please try again later.",
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "Next",
                                style: GoogleFonts.khand(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            // Terms and Conditions Text
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.038),
                              child: Text.rich(
                                TextSpan(
                                  style: GoogleFonts.roboto(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.028,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          "This site is protected by reCAPTCHA and Google’s",
                                    ),
                                    TextSpan(
                                      text: " Privacy Policy",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: " and"),
                                    TextSpan(
                                      text: " Terms and Conditions",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
