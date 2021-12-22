import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartPageView extends StatefulWidget{
  const StartPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
   return _StartPageViewView();
  }

}

class _StartPageViewView extends State<StartPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start page'),
      ),
      body: Text('Start page'),
    );
  }

}