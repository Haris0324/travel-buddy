import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Import your new signup page
import 'package:travel_buddy/signup.dart';
// Remove the 'main.dart' import, it's not needed
// import 'package:travel_buddy/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  signin() async {
    // You should add error handling here too, just like in signup
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
    } on FirebaseAuthException catch (e) {
      // Handle login errors (e.g., wrong password, user not found)
      String message = 'Failed to sign in. Check your credentials.';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: Padding(
        // Added padding for better UI
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(height: 10), // Added spacing
            TextField(
              controller: password,
              obscureText: true, // Hide password
              decoration: const InputDecoration(hintText: "Password"),
            ),
            const SizedBox(height: 20), // Added spacing
            ElevatedButton(
              onPressed: (() => signin()),
              child: const Text("Login"),
            ),

            // --- ADD THIS BUTTON ---
            TextButton(
              onPressed: () {
                // Navigate to the SignUpPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text("Don't have an account? Sign Up"),
            ),
            // ------------------------
          ],
        ),
      ),
    );
  }
}
