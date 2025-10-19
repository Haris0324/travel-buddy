import 'package:firebase_auth/firebase_auth.dart'; // Added Firebase import
import 'package:flutter/material.dart';
import 'login.dart'; // Assumes you have a 'signin_page.dart' file

class SignUpPage extends StatefulWidget {
  // Use const constructor
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Key for form validation
  final _signUpKey = GlobalKey<FormState>();

  // Renamed controllers to match the auth function
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // For password visibility
  bool _obscurePassword = true;

  // --- This is the signup() function from your second file ---
  Future<void> signup() async {
    // Show a loading circle (optional but good practice)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // This is the Firebase function to create a new user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(), // Use trim() to remove whitespace
        password: _password.text.trim(),
      );

      // If signup is successful, pop all pages until back to the wrapper
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle
      if (mounted) Navigator.pop(context);

      // Handle errors
      String message = 'An error occurred. Please try again.';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }

      // Show a snackbar with the error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- This is the dispose() method from your second file ---
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- This is the UI from your first file ---
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              // Title
              const Center(
                child: Text(
                  "Sign up now",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Center(
                child: Text(
                  "Please fill the details and create account",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 30),

              // Form Fields
              Form(
                key: _signUpKey,
                child: Column(
                  children: [
                    // --- USERNAME FIELD REMOVED ---

                    // Email
                    TextFormField(
                      controller: _email, // Updated controller
                      decoration: InputDecoration(
                        hintText: "abc@gmail.com",
                        filled: true,
                        fillColor: const Color(0xFFF7F7F9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        // Simple email validation
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 15),

                    // Password
                    TextFormField(
                      controller: _password, // Updated controller
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        // Use the same regex as your first file
                        final regex = RegExp(
                          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
                        );
                        if (!regex.hasMatch(value)) {
                          return "Password must be at least 8 characters, include upper & lowercase letters, a number, and a special character";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        errorMaxLines: 2, // Keep errorMaxLines
                        hintText: "**********",
                        filled: true,
                        fillColor: const Color(0xFFF7F7F9),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Password requirements text
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password must be at least 8 characters, include upper & lowercase letters, a number, and a special character",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // Check if the form is valid
                          if (_signUpKey.currentState!.validate()) {
                            // If valid, call the Firebase signup function
                            signup();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B4D8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Already have account text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigate back to SignInPage
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
