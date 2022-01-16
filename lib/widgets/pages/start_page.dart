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
        title: const Text('Zarządzanie firmą'),
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
            child: const Text(Strings.STUDENT_MANAGEMENT),
          ),
          ElevatedButton(
            onPressed: _navigateFinanceMainPage,
            child: const Text(Strings.FINANCE),
          ),
          ElevatedButton(
            onPressed: _navigatorClassesTypeMainPage,
            child: const Text(Strings.CLASSES_TYPE),
          ),
          ElevatedButton(
            onPressed: _navigateGroupsMainPage,
            child: const Text(Strings.GROUPS),
          ),
          ElevatedButton(
            onPressed: _navigatorClassesMainPage,
            child: const Text(Strings.CLASSES),
          ),
          ElevatedButton(
            onPressed: _navigateToTest,
            child: const Text('Test'),
          )
        ],
      ),
    );
  }

  void _navigateToTest() => Navigator.pushNamed(context, '/test');

  void _navigateToStudentsMainPage() =>
      Navigator.pushNamed(context, AppUrls.STUDENS_MAIN_PAGE,);

  void _navigateFinanceMainPage() =>
      Navigator.pushNamed(context, AppUrls.FINANCE_MAIN_PAGE);

  void _navigateGroupsMainPage() =>
      Navigator.pushNamed(context, AppUrls.GROUPS_MAIN_PAGE);

  void _navigatorClassesMainPage() =>
      Navigator.pushNamed(context, AppUrls.CLASSES_MAIN_PAGE);

  void _navigatorClassesTypeMainPage() =>
      Navigator.pushNamed(context, AppUrls.CLASSES_TYPE_MAIN_PAGE);
}
