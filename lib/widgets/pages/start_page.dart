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
        title: const Text(
          AppStrings.appTitle,
          style: TextStyle(
            fontSize: 40,
            fontFamily: AppStrings.fontLucianSchoenshrift,
          ),
        ),
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
              title: AppStrings.studentList.toLowerCase(),
              icon: const Icon(Icons.person),
              iconColor: Colors.orange.shade200),
          _button(
              onPressed: _navigateFinanceMainPage,
              title: AppStrings.finance.toLowerCase(),
              icon: const Icon(Icons.monetization_on),
              iconColor: Colors.lightBlue.shade200),
          _button(
              onPressed: _navigateToCreateClassesNewVersion,
              title: AppStrings.management.toLowerCase(),
              icon: const Icon(Icons.account_tree),
              iconColor: Colors.teal.shade200),
          _button(
              onPressed: _navigatorClassesTypeMainPage,
              title: AppStrings.classesType.toLowerCase(),
              icon: const Icon(Icons.title),
              iconColor: Colors.lightGreen.shade200),
          _button(
              onPressed: _navigateGroupsMainPage,
              title: AppStrings.groups.toLowerCase(),
              icon: const Icon(Icons.group),
              iconColor: Colors.purpleAccent.shade200),
          _button(
              onPressed: _navigatorClassesMainPage,
              title: AppStrings.classes.toLowerCase(),
              icon: const Icon(Icons.developer_board),
              iconColor: Colors.pink.shade200),
          _button(
              onPressed: _navigateToPhoneBook,
              title: AppStrings.phones.toLowerCase(),
              icon: const Icon(Icons.book),
              iconColor: Colors.brown.shade200),
          _button(
              onPressed: _navigatorLogMainPage,
              title: 'log',
              icon: const Icon(Icons.psychology),
              iconColor: Colors.green.shade200),
        ],
      ),
      drawer: _mainMenu(),
    );
  }

  _navigateToCreateClassesNewVersion() {
    Navigator.pushNamed(context, AppUrls.createClasses);
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
                    AppStrings.about,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: _navigateToManageDatabase,
                  child: const Text(
                    AppStrings.manageDatabase,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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

  void _navigateToAboutPage() => Navigator.pushNamed(context, AppUrls.about);

  void _navigateToManageDatabase() =>
      Navigator.pushNamed(context, AppUrls.manageDatabase);

  Widget _button(
      {required Icon icon,
      required String title,
      Function()? onPressed,
      Color iconColor = Colors.white}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: iconColor, // background
        onPrimary: Colors.white, // foreground
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            color: Colors.green.shade900,
            iconSize: 50,
            onPressed: onPressed,
            icon: icon,
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 10,
                  fontFamily: AppStrings.fontArchitectsDaughter),
            ),
          )
        ],
      ),
    );
  }

  void _navigateToPhoneBook() =>
      Navigator.pushNamed(context, AppUrls.phoneBook);

  void _navigateToStudentsMainPage() => Navigator.pushNamed(
        context,
        AppUrls.studentsMainPage,
      );

  void _navigateFinanceMainPage() =>
      Navigator.pushNamed(context, AppUrls.financeMainPage);

  void _navigateGroupsMainPage() =>
      Navigator.pushNamed(context, AppUrls.groupsMainPage);

  void _navigatorClassesMainPage() =>
      Navigator.pushNamed(context, AppUrls.classesMainPage);

  void _navigatorClassesTypeMainPage() =>
      Navigator.pushNamed(context, AppUrls.classesTypeMainPage);

  void _navigatorLogMainPage() =>
      Navigator.pushNamed(context, AppUrls.log);
}
