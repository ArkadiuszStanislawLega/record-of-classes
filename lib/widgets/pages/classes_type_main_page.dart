import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/widgets/templates/add_new_classes_type_template.dart';

class ClassTypeMainPage extends StatefulWidget {
  const ClassTypeMainPage({Key? key}) : super(key: key);

  @override
  _ClassTypeMainPageState createState() => _ClassTypeMainPageState();
}

class _ClassTypeMainPageState extends State<ClassTypeMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zajęcia'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {},
            child: Text('Dodaj zajęcia'),
          ),
          AddNewClassesTypeTemplate(),
        ],
      ),
    );
  }
}
