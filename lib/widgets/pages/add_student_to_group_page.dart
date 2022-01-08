import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/student.dart';

class AddStudentToGroupPage extends StatefulWidget {
  const AddStudentToGroupPage({Key? key}) : super(key: key);

  @override
  _AddStudentToGroupPageState createState() => _AddStudentToGroupPageState();
}

class _AddStudentToGroupPageState extends State<AddStudentToGroupPage> {
  late Group group;
  late Store _store;
  late Stream<List<Student>> _studentStream;

  @override
  Widget build(BuildContext context) {
    group = ModalRoute.of(context)!.settings.arguments as Group;
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
      ),
      body: StreamBuilder<List<Student>>(
        stream: _studentStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _store.box<Group>().get(group.id);
            var studentList = [];

            for (var student in snapshot.data!) {
              bool answer = false;
              for (var group in student.groups) {
                if (group.id == group.id){
                  answer = true;
                }
              }
              if (answer) studentList.add(student);
            }
            return ListView.builder(
              itemCount: studentList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Student student = studentList.elementAt(index);
                return Slidable(
                  actionPane: const SlidableDrawerActionPane(),
                  secondaryActions: [
                    IconSlideAction(
                      caption: Strings.ADD,
                      color: Colors.green,
                      icon: Icons.add,
                      onTap: () {
                        setState(() {
                          group.students.add(student);
                          student.groups.add(group);
                          _store.box<Group>().put(group);
                        });
                      },
                    ),
                  ],
                  child: ListTile(
                    title: Text(
                        '${student.person.target!.surname} ${student.person.target!.name}'),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppUrls.DETAIL_STUDENT,
                      arguments: snapshot.data!.elementAt(index),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _studentStream = _store
        .box<Student>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
