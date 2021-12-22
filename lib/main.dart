import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/widgets/pages/start_page.dart';


void main() {
  runApp(const RecordOfClassesApp());
}

class RecordOfClassesApp extends StatelessWidget {
  const RecordOfClassesApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rejestr zajęć',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      initialRoute: AppUrls.HOME,
      routes: {
        AppUrls.EMPTY: (context) => const StartPageView(),
        AppUrls.HOME: (context) => const StartPageView(),
      },
    );
  }
}
