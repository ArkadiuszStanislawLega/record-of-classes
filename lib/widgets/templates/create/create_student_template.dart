import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/enumerators/PersonType.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/create/create_person_template.dart';
import 'package:record_of_classes/widgets/templates/text_fields/text_field_template_num.dart';

class CreateStudentTemplate extends StatelessWidget {
  CreateStudentTemplate({Key? key}) : super(key: key);
  late Student _createdStudent;
  late Person _createdPerson;
  late Account _account;
  final _createPersonTemplate = CreatePersonTemplate();
  late TextFieldTemplateNum _getAge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          _createPersonTemplate,
          _getAge = TextFieldTemplateNum(label: AppStrings.age, hint: '')
        ],
      ),
    );
  }

  Student getStudent() {
    _createdPerson = _createPersonTemplate.getPerson();
    _createdStudent = Student(age: int.parse(_getAge.input));
    _account = Account()..student.target = _createdStudent;
    _createdStudent.account.target = _account;
    _createdPerson.dbPersonType = PersonType.student.index;
    _createdPerson.student.target = _createdStudent;
    _createdStudent.person.target = _createdPerson;
    return _createdStudent;
  }

  bool isValuesAreValid() =>
      int.parse(_getAge.input) > 0 && _createdPerson.name != '';

  void clearFields() {
    _getAge.clear();
    _createPersonTemplate.clearTemplate();
  }
}
