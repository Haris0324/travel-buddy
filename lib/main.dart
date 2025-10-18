import 'package:flutter/material.dart';
import 'signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Auth App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SignUpPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
