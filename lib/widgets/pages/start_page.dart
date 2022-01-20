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
          _button(
            onPressed: _navigateToStudentsMainPage,
            title: Strings.STUDENTS_LIST.toLowerCase(),
            icon: const Icon(Icons.person),
          ),
          _button(
              onPressed: _navigateFinanceMainPage,
              title: Strings.FINANCE.toLowerCase(),
              icon: const Icon(Icons.monetization_on)),
          _button(
              onPressed: _navigatorClassesTypeMainPage,
              title: Strings.CLASSES_TYPE.toLowerCase(),
              icon: const Icon(Icons.title)),
          _button(
              onPressed: _navigateGroupsMainPage,
              title: Strings.GROUPS.toLowerCase(),
              icon: const Icon(Icons.group)),
          _button(
              onPressed: _navigatorClassesMainPage,
              title: Strings.CLASSES.toLowerCase(),
              icon: const Icon(Icons.developer_board)),
          _button(
              onPressed: _navigateToPhoneBook,
              title: Strings.PHONES.toLowerCase(),
              icon: const Icon(Icons.book))
        ],
      ),
    );
  }

  Widget _button(
      {required Icon icon, required String title, Function()? onPressed}) {
    return Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              color: Colors.white,
              iconSize: 45,
              onPressed: onPressed,
              icon: icon,
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Arial',
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
  }

  void _navigateToPhoneBook() =>
      Navigator.pushNamed(context, AppUrls.PHONE_BOOK);

  void _navigateToStudentsMainPage() => Navigator.pushNamed(
        context,
        AppUrls.STUDENS_MAIN_PAGE,
      );

  void _navigateFinanceMainPage() =>
      Navigator.pushNamed(context, AppUrls.FINANCE_MAIN_PAGE);

  void _navigateGroupsMainPage() =>
      Navigator.pushNamed(context, AppUrls.GROUPS_MAIN_PAGE);

  void _navigatorClassesMainPage() =>
      Navigator.pushNamed(context, AppUrls.CLASSES_MAIN_PAGE);

  void _navigatorClassesTypeMainPage() =>
      Navigator.pushNamed(context, AppUrls.CLASSES_TYPE_MAIN_PAGE);
}
