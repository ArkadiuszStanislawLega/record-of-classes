import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/accounts_list_template.dart';

class StudentDetailPage extends StatefulWidget{
  const StudentDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentDetailPage();
  }
}

class _StudentDetailPage extends State<StudentDetailPage>{

  late Student? student;

  @override
  Widget build(BuildContext context) {
    student =  ModalRoute.of(context)!.settings.arguments as Student;
    var person = student!.person.target;

    return Scaffold(
      appBar: AppBar(
        title: Text('${person!.name}  ${person!.surname}'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text('Wiek: ${student!.age.toString()}'),
            AccountListTemplate(account: student!.account)
          ],
        ),
      ),
    );
  }

}