import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/teacher.dart';
import 'package:record_of_classes/widgets/templates/add_new_classes_type_template.dart';
import 'package:record_of_classes/widgets/templates/classes_type_list_template.dart';

class ClassTypeMainPage extends StatefulWidget {
  const ClassTypeMainPage({Key? key}) : super(key: key);

  @override
  _ClassTypeMainPageState createState() => _ClassTypeMainPageState();
}

class _ClassTypeMainPageState extends State<ClassTypeMainPage> {
  final AddNewClassesTypeTemplate _addNewClassesTypeTemplate =
      AddNewClassesTypeTemplate();
  late Store _store;
  late Stream<List<ClassesType>> _classesTypesStream;

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
                _addClassesTypeToDb(_createClassesType(_getTeacherFromDb()));
                _addNewClassesTypeTemplate.clearFields();
              }
            },
            child: const Text(Strings.ADD_CLASSES_TYPE),
          ),
          StreamBuilder<List<ClassesType>>(
            stream: _classesTypesStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ClassesTypeListTemplate(classesTypes: snapshot.data!,);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
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

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _classesTypesStream = _store
        .box<ClassesType>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
