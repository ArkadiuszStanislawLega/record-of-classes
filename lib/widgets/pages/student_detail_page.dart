import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/accounts_list_template.dart';

class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentDetailPage();
  }
}

class _StudentDetailPage extends State<StudentDetailPage> {
  late Student student;
  late bool isEdited = false;

  @override
  Widget build(BuildContext context) {
    String personAge = '', personName = '', personSurname = '';
    student = ModalRoute.of(context)!.settings.arguments as Student;
    Person person = student.person.target as Person;

    return Scaffold(
      appBar: AppBar(
        title: Text('${person.name}  ${person.surname}'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: isEdited
              ? [
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: Strings.NAME,
                    ),
                    onChanged: (userInput) => setState(
                      () {
                        personName = userInput;
                      },
                    ),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: Strings.SURNAME,
                    ),
                    onChanged: (userInput) => setState(
                      () {
                        personSurname = userInput;
                      },
                    ),
                  ),
                  TextField(
                      onChanged: (value) {
                        personAge = value;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: Strings.AGE,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEdited = false;

                      });
                    },
                    child: const Text(Strings.OK),
                  )
                ]
              : [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEdited = true;
                      });
                    },
                    child: const Text(Strings.EDIT),
                  ),
                  Text('${Strings.AGE}: ${student.age.toString()}'),
                  AccountListTemplate(account: student.account)
                ],
        ),
      ),
    );
  }
}
