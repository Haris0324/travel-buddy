import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_buddy/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  signin() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text,
      password: password.text,
    );
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: Column(
        children: [
          TextField(
            controller: email,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          TextField(
            controller: password,
            decoration: const InputDecoration(hintText: "Password"),
          ),
          ElevatedButton(
            onPressed: (() => signin()),
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }
}
