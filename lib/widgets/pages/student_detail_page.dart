import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
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
  late Store _store;
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
                    decoration: InputDecoration(
                      hintText: person.name == '' ? Strings.NAME : person.name,
                    ),
                    onChanged: (userInput) {
                      personName = userInput;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: person.surname == ''
                          ? Strings.SURNAME
                          : person.surname,
                    ),
                    onChanged: (userInput) {
                      personSurname = userInput;
                    },
                  ),
                  TextField(
                      onChanged: (userInput) {
                        personAge = userInput;
                      },
                      decoration: InputDecoration(
                        hintText: student.age == 0
                            ? Strings.AGE
                            : student.age.toString(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                  TextButton(
                    onPressed: () {
                      _store = objectBox.store;

                      if (personName != '') {
                        student.person.target!.name = personName;
                      }
                      if (personSurname != '') {
                        student.person.target!.surname = personSurname;
                      }
                      if (personAge != '') {
                        student.age = int.parse(personAge);
                      }

                      _store.box<Student>().put(student);

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
