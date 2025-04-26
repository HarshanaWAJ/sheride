import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sheride/views/auth/login.dart';
import 'package:sheride/utils/login_reg_utils.dart';
import 'package:sheride/views/auth/otp.dart';
import 'package:sheride/views/home.dart'; // Make sure the AuthUtils file is imported

class RegisterPage extends StatefulWidget {
  final String mobileNumber;

  const RegisterPage({super.key, required this.mobileNumber});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: EdgeInsets.only(
                top: screenHeight * 0.01,
                bottom: screenHeight * 0.01,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    Image.asset(
                      'assets/images/logo.png',
                      height: screenHeight * 0.15,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // App name
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.khand(
                          fontSize: screenWidth * 0.15,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              offset: Offset(5.0, 5.0),
                              blurRadius: 5.0,
                              color: Color.fromARGB(80, 0, 0, 0),
                            ),
                          ],
                        ),
                        children: [
                          TextSpan(
                            text: "she ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: "Taxi",
                            style: TextStyle(color: Colors.pink),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Form Container
                    Container(
                      width: screenWidth * 0.9,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(50, 233, 30, 98),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Your Details",
                            style: GoogleFonts.roboto(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold,
                              color: Colors.pink,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Mobile Number Display
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Mobile Number: ${formatMobileNumber(widget.mobileNumber)}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Change Number",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // First Name & Last Name Row
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter first name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter last name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // Email Field
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              if (!value.contains('@')) {
                                return 'Enter valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // Birthday & Gender Row
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Birthday',
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Colors.white,
                                        suffixIcon: Icon(Icons.calendar_today),
                                      ),
                                      controller: TextEditingController(
                                        text:
                                            _selectedDate != null
                                                ? DateFormat(
                                                  'yyyy-MM-dd',
                                                ).format(_selectedDate!)
                                                : '',
                                      ),
                                      validator: (value) {
                                        if (_selectedDate == null) {
                                          return 'Select birthday';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: _selectedGender,
                                  decoration: InputDecoration(
                                    labelText: 'Gender',
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  items: [
                                    DropdownMenuItem(
                                      value: 'Male',
                                      child: Text('Male'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Female',
                                      child: Text('Female'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Other',
                                      child: Text('Other'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Select gender';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.05),

                          // Next Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  AuthUtils.saveUserData(
                                        firstName:
                                            _firstNameController.text.trim(),
                                        lastName:
                                            _lastNameController.text.trim(),
                                        email: _emailController.text.trim(),
                                        mobileNumber: widget.mobileNumber,
                                        birthday: _selectedDate,
                                        gender: _selectedGender,
                                      )
                                      .then((_) {
                                        // Navigate to the next page if successful
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                      })
                                      .catchError((e) {
                                        // Handle error here (e.g., show a snackbar)
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error saving data. Please try again.',
                                            ),
                                          ),
                                        );
                                      });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String formatMobileNumber(String mobileNumber) {
    if (mobileNumber.length >= 6) {
      return "${mobileNumber.substring(0, 3)}****${mobileNumber.substring(mobileNumber.length - 3)}";
    }
    return mobileNumber;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
