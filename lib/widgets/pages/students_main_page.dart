import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/widgets/templates/create/create_student_template.dart';
import 'package:record_of_classes/widgets/templates/lists/students_list_template.dart';

class StudentsMainPage extends StatefulWidget {
  const StudentsMainPage({Key? key}) : super(key: key);

  @override
  _StudentsMainPageState createState() => _StudentsMainPageState();
}

class _StudentsMainPageState extends State<StudentsMainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(Strings.STUDENT_MANAGEMENT),
            bottom: const TabBar(
              tabs: [
                Tab(text: Strings.CREATE_STUDENT),
                Tab(text: Strings.STUDENTS_LIST),
              ],
            ),
          ),
          body: TabBarView(
            children: [CreateStudentTemplate(), const StudentsListTemplate()],
          )),
    );
  }
}
