import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/teacher.dart';
import 'package:record_of_classes/widgets/templates/add_new_classes_type_template.dart';

class ClassTypeMainPage extends StatefulWidget {
  const ClassTypeMainPage({Key? key}) : super(key: key);

  @override
  _ClassTypeMainPageState createState() => _ClassTypeMainPageState();
}

class _ClassTypeMainPageState extends State<ClassTypeMainPage> {
  final AddNewClassesTypeTemplate _addNewClassesTypeTemplate =
      AddNewClassesTypeTemplate();
  late Store _store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.CLASSES),
      ),
      body: Column(
        children: [
          _addNewClassesTypeTemplate,
          TextButton(
            onPressed: () {
              if (_addNewClassesTypeTemplate.isInputValid()) {
                _store = objectBox.store;
                _addClassesTypeToDb(_createClassesType(_getTeacherFromDb()));
                _addNewClassesTypeTemplate.clearFields();
              }
            },
            child: const Text(Strings.ADD_CLASSES_TYPE),
          ),
        ],
      ),
    );
  }

  Teacher _getTeacherFromDb() => _store.box<Teacher>().getAll().elementAt(0);

  ClassesType _createClassesType(Teacher teacher) =>
      _addNewClassesTypeTemplate.getClassType()..teacher.target = teacher;

  void _addClassesTypeToDb(ClassesType classesType) =>
      _store.box<ClassesType>().put(classesType);
}
