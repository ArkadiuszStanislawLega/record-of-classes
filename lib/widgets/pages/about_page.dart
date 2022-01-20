import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(Strings.ABOUT),),
      body: Container(padding: const EdgeInsets.all(30.0),
          child: Column(
        children: const [
          Text('Autorem i właścicielem praw jest Arkadiusz Łęga, błędy i problemy proszę zgłaszać na adres e-mail: horemhe@vp.pl'),
        ],
      ),)
    );
  }
}
