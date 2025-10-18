import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Create controllers for email and password
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // The signup function
  Future<void> signup() async {
    try {
      // This is the Firebase function to create a new user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      );

      // If signup is successful, pop the page to go back
      // The wrapper will automatically redirect to Homepage
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      // Handle errors (e.g., email already in use, weak password)
      String message = 'An error occurred. Please try again.';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      }

      // Show a snackbar with the error message
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")), // Has a back button
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(hintText: "Enter Email"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _password,
              obscureText: true, // Hides the password
              decoration: const InputDecoration(hintText: "Enter Password"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signup, // Call your signup function
              child: const Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
