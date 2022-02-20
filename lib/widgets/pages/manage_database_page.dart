import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';

class ManageDatabasePage extends StatefulWidget {
  const ManageDatabasePage({Key? key}) : super(key: key);

  @override
  _ManageDatabasePageState createState() => _ManageDatabasePageState();
}

class _ManageDatabasePageState extends State<ManageDatabasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.MANAGE_DATABASE,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Text('content'),
      ),
    );
  }
}
