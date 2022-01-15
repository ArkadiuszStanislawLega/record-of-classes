import 'package:flutter/material.dart';

class GroupsMainPage extends StatefulWidget {
  const GroupsMainPage({Key? key}) : super(key: key);

  @override
  _GroupsMainPageState createState() => _GroupsMainPageState();
}

class _GroupsMainPageState extends State<GroupsMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups Main page'),
      ),
      body: Column(),
    );
  }
}
