import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';

class StartPageView extends StatefulWidget {
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
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppUrls.CREATE_STUDENT,
              );
            },
            child: Text('Utworz studenta'),
          ),
        ],
      ),
    );
  }
}
