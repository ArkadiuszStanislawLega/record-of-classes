import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/enumerators/PersonType.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/create/create_person_template.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          _createPersonTemplate,
          TextField(
              controller: _ageController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(
                  AppStrings.AGE,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              onChanged: (userInput) => _personAge = userInput),
        ],
      ),
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
