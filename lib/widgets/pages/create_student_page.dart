import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/objectbox.g.dart';

import '../../main.dart';

class CreateStudentPage extends StatefulWidget {
  const CreateStudentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateStudentPage();
  }
}

class _CreateStudentPage extends State<CreateStudentPage> {
  late Store _store;
  bool hasBeenInitialized = false;
  String personName = '', personSurname = '', personAge = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create student page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: Strings.NAME,
              ),
              onChanged: (userInput) => personName = userInput
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: Strings.SURNAME,
              ),
              onChanged: (userInput) => personSurname = userInput
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: Strings.AGE,
              ),
              onChanged: (userInput) => personAge = userInput
            ),
            ElevatedButton(
              onPressed: () {
                createNewPerson();
                Navigator.pop(
                  context,
                );
              },
              child: const Text(Strings.CREATE_STUDENT),
            ),
          ],
        ),
      ),
    );
  }

  void createNewPerson() {
    var person = Person(name: personName, surname: personSurname);
    var student = Student(age: int.parse(personAge));
    var account = Account();

    student.person.target = person;
    account.student.target = student;
    _store.box<Student>().put(student);
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
  }
}
