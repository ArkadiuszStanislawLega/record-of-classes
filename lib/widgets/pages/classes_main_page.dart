import 'package:flutter/material.dart';

class ClassesMainPage extends StatefulWidget {
  const ClassesMainPage({Key? key}) : super(key: key);

  @override
  _ClassesMainPageState createState() => _ClassesMainPageState();
}

class _ClassesMainPageState extends State<ClassesMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Classes main page'),),
      body: Column(),
    );
  }
}
