import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/student.dart';

class AddStudentToGroupPage extends StatefulWidget {
  const AddStudentToGroupPage({Key? key}) : super(key: key);

  @override
  _AddStudentToGroupPageState createState() => _AddStudentToGroupPageState();
}

class _AddStudentToGroupPageState extends State<AddStudentToGroupPage> {
  late Group _group;
  late Stream<List<Student>> _studentStream;

  @override
  Widget build(BuildContext context) {
    _group = ModalRoute.of(context)!.settings.arguments as Group;
    return Scaffold(
      appBar: AppBar(
        title: Text(_group.name),
      ),
      body: StreamBuilder<List<Student>>(
        stream: _studentStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _studentsListView(snapshot.data!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _studentsListView(List<Student> listFromDatabase) {
    List<Student> filteredList = _createUnattachedStudentsList(listFromDatabase);

    return ListView.builder(
      itemCount: filteredList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _studentListItem(filteredList.elementAt(index));
      },
    );
  }


  List<Student> _createUnattachedStudentsList(List<Student> listFromDatabase){
    List<Student> studentList = [];
    for (var student in listFromDatabase) {
      if (!_isStudentInGroup(student)) {
        studentList.add(student);
      }
    }
    return studentList;
  }

  bool _isStudentInGroup(Student student){
    for (int i = 0; i < _group.students.length; i++) {
      if (student.id == _group.students.elementAt(i).id) {
        return true;
      }
    }
    return false;
  }

  Widget _studentListItem(Student student) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: AppStrings.add,
          color: Colors.green,
          icon: Icons.add,
          onTap: () => _updateDatabase(student),
        ),
      ],
      child: _studentListTile(student)
    );
  }

  Widget _studentListTile(Student student){
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 5.0, left: 5.0),
      child: ListTile(
        title: Text(student.introduceYourself()),
        onTap: () => Navigator.pushNamed(
          context,
          AppUrls.detailStudent,
          arguments: {AppStrings.student: student},
        ),
      ),
    );
  }

  void _updateDatabase(Student student) {
    setState(() {
      _group.students.add(student);
      student.groups.add(_group);
      _group.addToDb();
      student.addToDb();
    });
  }

  @override
  void initState() {
    super.initState();
    _studentStream = ObjectBox.store
        .box<Student>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
