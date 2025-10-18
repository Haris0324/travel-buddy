import 'package:flutter/material.dart';

void main() {
  runApp(MyPage());
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello",
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: BList(),
    );
  }
}

class BList extends StatefulWidget {
  @override
  State<BList> createState() {
    return StudentsList();
  }
}

class StudentsList extends State<BList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Students List")),
      body: Center(

      )
    );
  }
}
