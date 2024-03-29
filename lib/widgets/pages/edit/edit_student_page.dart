import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';
import 'package:record_of_classes/widgets/templates/text_fields/text_field_template.dart';
import 'package:record_of_classes/widgets/templates/text_fields/text_field_template_num.dart';

class EditStudentPage extends StatefulWidget {
  const EditStudentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditStudentPage();
  }
}

class _EditStudentPage extends State<EditStudentPage> {
  late Student _student;
  late Person _person;
  late Function _updateStudentInDb;
  late Map _args;

  late TextFieldTemplate _name, _surname;
  late TextFieldTemplateNum _age;

  @override
  Widget build(BuildContext context) {
    _initValues();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _student.introduceYourself(),
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        body: _content());
  }

  void _initValues() {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _student = _args[AppStrings.student];
    _updateStudentInDb = _args[AppStrings.function];
    _person = _student.person.target!;

    _name = TextFieldTemplate(label: AppStrings.name, hint: _person.name);
    _surname = TextFieldTemplate(
      label: AppStrings.surname,
      hint: _person.surname,
    );
    _age = TextFieldTemplateNum(
        label: AppStrings.age, hint: _student.age.toString());
  }

  Widget _content() {
    return Column(
      children: [
        _name,
        _surname,
        _age,
        Center(
          child: TextButton(
            onPressed: confirmEditChanges,
            child: const Text(AppStrings.ok),
          ),
        ),
      ],
    );
  }



  bool _isNameValid() => _name.input != '';

  bool _isSurnameValid() => _surname.input != '';

  bool _isAgeValid() {
    if (_age.input == '') {
      return false;
    }
    if (int.tryParse(_age.input) == 0) {
      return false;
    }
    if (int.parse(_age.input) > 0) {
      return true;
    }

    return false;
  }

  void confirmEditChanges() {
    _updateStudentInDb(
        name: _isNameValid() ? _name.input : _person.name,
        surname: _isSurnameValid() ? _surname.input : _person.surname,
        age: _isAgeValid() ? int.parse(_age.input) : _student.age);
    SnackBarInfoTemplate(
        context: context,
        message:
            '${AppStrings.successFullyUpdatedStudent} ${_student.introduceYourself()}');
    Navigator.pop(context);
  }
}
