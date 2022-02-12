import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';

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
        title: const Text('Zarządzanie firmą', style: TextStyle(
          fontFamily: 'ArchitectsDaughter'
        ),),
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
            title: AppStrings.STUDENTS_LIST.toLowerCase(),
            icon: const Icon(Icons.person),
            iconColor: Colors.orange.shade200
          ),
          _button(
              onPressed: _navigateFinanceMainPage,
              title: AppStrings.FINANCE.toLowerCase(),
              icon: const Icon(Icons.monetization_on),
              iconColor: Colors.lightBlue.shade200),

          _button(
              onPressed: _navigateToCreateClassesNewVersion,
              title: AppStrings.MANAGEMENT.toLowerCase(),
              icon: const Icon(Icons.account_tree),
              iconColor: Colors.teal.shade200),
          _button(
              onPressed: _navigatorClassesTypeMainPage,
              title: AppStrings.CLASSES_TYPE.toLowerCase(),
              icon: const Icon(Icons.title),
              iconColor: Colors.lightGreen.shade200),
          _button(
              onPressed: _navigateGroupsMainPage,
              title: AppStrings.GROUPS.toLowerCase(),
              icon: const Icon(Icons.group),
              iconColor: Colors.yellowAccent.shade200),
          _button(
              onPressed: _navigatorClassesMainPage,
              title: AppStrings.CLASSES.toLowerCase(),
              icon: const Icon(Icons.developer_board),
              iconColor: Colors.pink.shade200),
          _button(
              onPressed: _navigateToPhoneBook,
              title: AppStrings.PHONES.toLowerCase(),
              icon: const Icon(Icons.book),
              iconColor: Colors.tealAccent.shade200),
        ],
      ),
      drawer: _mainMenu(),
    );
  }

  _navigateToCreateClassesNewVersion(){
    Navigator.pushNamed(context, AppUrls.CREATE_CLASSES_NEW_VERSION);
  }

  Widget _mainMenu() {
    return Container(
      color: Colors.blueGrey,
      width: 200,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextButton(
                    onPressed: _navigateToAboutPage,
                    child: const Text(
                      AppStrings.ABOUT,
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            const Text(
              'v.1.0.0',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAboutPage() => Navigator.pushNamed(context, AppUrls.ABOUT);

  Widget _button(
      {required Icon icon, required String title, Function()? onPressed, Color iconColor = Colors.white}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            color: iconColor,
            iconSize: 50,
            onPressed: onPressed,
            icon: icon,
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontFamily: 'CroissantOne',
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
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
