import 'package:flutter/material.dart';

void main() {
  runApp(SignIn());
}

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello",
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  @override
  State<SignInPage> createState() {
    return SignInPageState();
  }
}

class SignInPageState extends State<SignInPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              print("Circular Button Pressed!");
            },
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),   // 👈 Makes the button circular
              padding: const EdgeInsets.all(24), // Controls the size of the circle
              backgroundColor: Colors.blue,  // Button color
              foregroundColor: Colors.white, // Icon/Text color
              elevation: 6,
            ),
            child: const Icon(Icons.add, size: 28),
          )
        ],
      )
    );
  }
}
