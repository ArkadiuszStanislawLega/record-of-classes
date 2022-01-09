import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
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
  late Student student;
  late Store _store;
  late Stream<List<Student>> _studentsStream;

  @override
  Widget build(BuildContext context) {
    student = ModalRoute.of(context)!.settings.arguments as Student;
    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${Strings.ADD_SIBLING} ${student.person.target!.surname} ${student.person.target!.name}')),
      body: Container(
        margin: const EdgeInsets.all(5),
        child: StreamBuilder<List<Student>>(
          stream: _studentsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Student> preparedStudentList = prepareData(_createUnattachedSiblings(snapshot.data!));
              return ListView.builder(
                itemCount: preparedStudentList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SiblingsListItemTemplate(
                          sibling: preparedStudentList.elementAt(index),
                          student: student,
                        );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  List<Student> _createUnattachedSiblings(List<Student> listFromDb){
    List<Student> notAttachedStudents = [];
    for (var dbStudent in listFromDb) {
      if (!_isSiblingsAreConnected(dbStudent)){
        notAttachedStudents.add(dbStudent);
      }
    }
    return notAttachedStudents;
  }

  bool _isSiblingsAreConnected(Student student){
    for (var siblings in student.siblings) {
      if (student.id == siblings.id){
        return true;
      }
    }
    return false;
  }


  List<Student> prepareData(var originalData){
    List<Student> studentList = [];
    originalData.sort((Student a, Student b) => a.person.target!.surname
        .toLowerCase()
        .compareTo(b.person.target!.surname.toLowerCase()));
    for (var stud in originalData) {
      if (stud.id != student.id) studentList.add(stud);
    }
    return studentList;
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _studentsStream = _store
        .box<Student>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
