import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/web.dart';
import 'package:sheride/views/auth/login.dart';
import 'package:sheride/views/auth/register.dart';
import 'package:sheride/views/home.dart';
import 'package:sheride/utils/login_reg_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerifyPage extends StatefulWidget {
  final String mobileNumber;
  final String verificationId;
  const OtpVerifyPage({
    super.key,
    required this.mobileNumber,
    required this.verificationId,
  });

  @override
  _OtpVerifyPageState createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  // List to hold OTP input fields' values (now with 6 fields)
  List<String> otp = ["", "", "", "", "", ""];
  final _focusNodes = List.generate(6, (index) => FocusNode());
  Logger logger = Logger();

  // Function to handle OTP change in each text field
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      otp[index] = value; // Update OTP value at the specific index
      // Move focus to the next field if it's not the last one
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      }
    } else {
      otp[index] = ""; // Clear value if user deletes it
    }
  }

  // Function to handle OTP verification
  void verifyOtp() async {
    String enteredOtp =
        otp.join(); // Combine the OTP digits into a single string
    if (enteredOtp.length == 6) {
      logger.i("OTP Entered: $enteredOtp");

      try {
        // OTP Verification
        final cred = PhoneAuthProvider.credential(
          verificationId: widget.verificationId,
          smsCode: enteredOtp,
        );

        // Sign in with credential asynchronously
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(cred);
        final uid = userCredential.user?.uid;
        try {
          if (uid != null) {
            // Check User ID
            bool existUser = await AuthUtils.doesUserExist(widget.mobileNumber);
            logger.i("User Detais found: $existUser");

            // Handle Login and Registration
            if (existUser == true) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('user_uid', uid); // Saving the UID

              // Navigate to the Home Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else {
              // Navigate to Register Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => RegisterPage(
                        mobileNumber: widget.mobileNumber,
                      ), // Passing the mobileNumber
                ),
              );
            }
          }
        } catch (e) {
          logger.e("Error with login registration utils");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Failed! with error: $e")),
          );
        }
      } catch (e) {
        // Handle errors (e.g., wrong OTP or network issues)
        logger.e("Error during OTP verification: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP verification failed. Please try again.")),
        );
      }
    } else {
      // Show a message if the OTP is incomplete
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please enter the full OTP")));
    }
  }

  @override
  void dispose() {
    // Dispose all focus nodes to avoid memory leaks
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: screenHeight * 0.01,
              bottom: screenHeight * 0.01,
              left: screenWidth * 0.01,
              right: screenWidth * 0.01,
            ),
            child: Column(
              children: [
                // -------------------------------------------- Start of Logo --------------------------------------------
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
                        offset: Offset(5.0, 5.0), // Shadow position
                        blurRadius: 5.0, // Blur radius
                        color: const Color.fromARGB(
                          80,
                          0,
                          0,
                          0,
                        ), // Shadow color with opacity
                      ),
                    ],
                  ),
                ),
                // -------------------------------------------- End of Logo --------------------------------------------
                SizedBox(height: screenHeight * 0.015),
                // -------------------------------------------- Start of OTP Section -----------------------------------
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      color: const Color.fromARGB(50, 233, 30, 98),
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.04),
                          Text(
                            "Verification Code",
                            style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: screenWidth * 0.06,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: "We have sent the verification code to ",
                                style: GoogleFonts.roboto(
                                  color: Colors.grey.shade700,
                                  fontSize: screenWidth * 0.035,
                                  letterSpacing: 1,
                                ),
                                children: [
                                  TextSpan(
                                    text: formatMobileNumber(
                                      widget.mobileNumber,
                                    ), // Use the formatted mobile number
                                    style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      color:
                                          Colors
                                              .grey
                                              .shade700, // Style for the mobile number
                                    ),
                                  ),
                                  TextSpan(
                                    text: " Change Number?",
                                    style: GoogleFonts.roboto(
                                      color: Colors.pink,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => LoginPage(),
                                              ),
                                            );
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.025),

                          // Input Field for OTP
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(6, (index) {
                                return SizedBox(
                                  height: 52,
                                  width: 48,
                                  child: TextField(
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.pink,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.pinkAccent,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    onChanged:
                                        (value) => onOtpChanged(value, index),
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          ElevatedButton(
                            onPressed: verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors
                                      .pinkAccent, // Set background color to pinkAccent
                              minimumSize: Size(
                                screenWidth * 0.8,
                                screenHeight * 0.06,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  screenWidth *
                                      0.03, // Rounded corners with responsive size
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                              ), // Set padding to match the TextButton
                            ),
                            child: Text(
                              "Verify OTP",
                              style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.04,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
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
    );
  }

  formatMobileNumber(String mobileNumber) {
    if (mobileNumber.length >= 6) {
      // Show first 3 digits, replace middle with asterisks, and show last 3 digits
      return "${mobileNumber.substring(0, 3)}****${mobileNumber.substring(mobileNumber.length - 3)}";
    } else {
      // If the number is too short (less than 6 digits), return it as is
      return mobileNumber;
    }
  }
}
