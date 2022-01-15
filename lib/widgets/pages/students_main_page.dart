import 'package:flutter/material.dart';
import 'package:record_of_classes/widgets/pages/create/create_student_page.dart';
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
            title: Text('List uczniów'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Nowy uczeń',
                ),
                Tab(
                  text: 'Lista czuniów',
                )
              ],
            )),
        body: TabBarView(
          children: [
            CreateStudentTemplate(),
            const StudentsListTemplate()
          ],
        )
      ),
    );
  }
}
