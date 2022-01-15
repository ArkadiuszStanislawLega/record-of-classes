import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/widgets/templates/lists/students_list_template.dart';

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
        title: const Text('Start page'),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: <Widget>[
          ElevatedButton(
            onPressed: _navigateToStudentsMainPage,
            child: Text('Zarządzanie uczniami'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Finanse'),
          ),
          ElevatedButton(
            onPressed: _navigateClassesType,
            child: Text('Rodzaj zajęć'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Grupy'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Zajęcia'),
          )
        ],
      ),
    );
  }

  void _navigateToStudentsMainPage() => Navigator.pushNamed(
        context,
        AppUrls.STUDENS_MAIN_PAGE,
      );

  void _navigateClassesType() =>
      Navigator.pushNamed(context, AppUrls.CLASS_TYPE_MAIN);
}
