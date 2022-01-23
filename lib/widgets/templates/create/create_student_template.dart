import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/enumerators/PersonType.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/objectbox.g.dart';
import 'package:record_of_classes/widgets/templates/create/create_person_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class CreateStudentTemplate extends StatelessWidget {
  CreateStudentTemplate({Key? key}) : super(key: key);
  String _personAge = '';
  late Student _createdStudent;
  late Person _createdPerson;
  late Account _account;
  final _createPersonTemplate = CreatePersonTemplate();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _createPersonTemplate,
        TextField(
            controller: _ageController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.AGE,
            ),
            onChanged: (userInput) => _personAge = userInput),
      ],
    );
  }

  Student getStudent() {
    _createdPerson = _createPersonTemplate.getPerson();
    _createdStudent = Student(age: int.parse(_personAge));
    _account = Account()..student.target = _createdStudent;
    _createdStudent.account.target = _account;
    _createdPerson.dbPersonType = PersonType.student.index;
    _createdPerson.student.target = _createdStudent;
    _createdStudent.person.target = _createdPerson;
    return _createdStudent;
  }

  bool isValuesAreValid() =>
      int.parse(_personAge) > 0 && _createdPerson.name != '';

  void clearFields() {
    _personAge = '';
    _ageController.clear();
    _createPersonTemplate.clearTemplate();
  }
}
