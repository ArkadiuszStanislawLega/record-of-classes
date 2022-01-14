import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/teacher.dart';
import 'package:record_of_classes/widgets/templates/add_new_classes_type_template.dart';
import 'package:record_of_classes/widgets/templates/lists/classes_type_list_template.dart';

class ClassTypePage extends StatefulWidget {
  const ClassTypePage({Key? key}) : super(key: key);

  @override
  _ClassTypePageState createState() => _ClassTypePageState();
}

class _ClassTypePageState extends State<ClassTypePage> {
  final AddNewClassesTypeTemplate _addNewClassesTypeTemplate =
      AddNewClassesTypeTemplate();
  late Store _store;
  late Stream<List<ClassesType>> _classesTypesStream;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.CLASSES),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Nowy typ'),
              Tab(text: 'Lista typów'),
            ],
          ),
        ),
        body: StreamBuilder<List<ClassesType>>(
          stream: _classesTypesStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TabBarView(
                children: [
                  _createNewClassesType(),
                  ClassesTypeListTemplate(
                    classesTypes: snapshot.data!,
                  )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _createNewClassesType() {
    return Column(
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
      ],
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
