import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/list_items/siblings_list_item_template.dart';

class AddSiblingsToStudentPage extends StatefulWidget {
  const AddSiblingsToStudentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddSiblingsPage();
  }
}

class _AddSiblingsPage extends State<AddSiblingsToStudentPage> {
  late Student _student;
  late Stream<List<Student>> _studentsStream;
  late Function _addSiblingsToDb;
  late Map _args;

  @override
  Widget build(BuildContext context) {
    _args =  ModalRoute.of(context)!.settings.arguments as Map;
    _student = _args[AppStrings.STUDENT];
    _addSiblingsToDb = _args[AppStrings.FUNCTION];

    return Scaffold(
      appBar: AppBar(
          title: Text('${AppStrings.ADD_SIBLING} ${_student.introduceYourself()}'),),
      body: StreamBuilder<List<Student>>(
        stream: _studentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _unattachedSiblingListView(_sortData(_createUnattachedSiblings(snapshot.data!)));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _unattachedSiblingListView(List<Student> unattachedSiblings) {
    return ListView.builder(
      itemCount: unattachedSiblings.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SiblingsListItemTemplate(
          sibling: unattachedSiblings.elementAt(index),
          student: _student,
          addSiblingToDb: _addSiblingsToDb,
        );
      },
    );
  }

  List<Student> _createUnattachedSiblings(List<Student> listFromDb) {
    List<Student> notAttachedStudents = [];
    for (var dbStudent in listFromDb) {
      if (!_isSiblingsAreConnected(dbStudent)) {
        notAttachedStudents.add(dbStudent);
      }
    }
    return notAttachedStudents;
  }

  bool _isSiblingsAreConnected(Student dbStudent) {
    for (var siblings in _student.siblings) {
      if (dbStudent.id == siblings.id) {
        return true;
      }
    }
    return false;
  }

  List<Student> _sortData(var originalData) {
    List<Student> studentList = [];
    originalData.sort((Student a, Student b) => a.person.target!.surname
        .toLowerCase()
        .compareTo(b.person.target!.surname.toLowerCase()));
    for (var stud in originalData) {
      if (stud.id != _student.id) studentList.add(stud);
    }
    return studentList;
  }

  @override
  void initState() {
    super.initState();
    _studentsStream = objectBox.store
        .box<Student>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
