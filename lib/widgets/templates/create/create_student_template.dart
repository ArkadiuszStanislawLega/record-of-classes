import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/objectbox.g.dart';
import 'package:record_of_classes/widgets/templates/create/create_person_template.dart';

class CreateStudentTemplate extends StatelessWidget {
  CreateStudentTemplate({Key? key}) : super(key: key);
  String _personAge = '';
  final _createPersonTemplate = CreatePersonTemplate();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _createPersonTemplate,
        TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.AGE,
            ),
            onChanged: (userInput) => _personAge = userInput
        ),
        ElevatedButton(
          onPressed: _onPressCreateButtonEvent,
          child: const Text(Strings.CREATE_STUDENT),
        ),
      ],
    );
  }

  void _onPressCreateButtonEvent() {
    _addToDatabase(_createNewPerson());
  }

  Person _createNewPerson() {
    var person = _createPersonTemplate.getPerson();
    var student = Student(age: int.parse(_personAge));
    var account = Account();

    student.account.target = account;
    person.student.target = student;
    student.person.target = person;

    return person;
  }


  void _addToDatabase(Person person){
    Store store;
    store = objectBox.store;
    store.box<Person>().put(person);
  }
}
