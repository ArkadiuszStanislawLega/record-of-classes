import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';
import 'package:record_of_classes/widgets/templates/text_field_template.dart';
import 'package:record_of_classes/widgets/templates/text_field_template_num.dart';

class EditStudentPage extends StatefulWidget {
  EditStudentPage({Key? key}) : super(key: key);

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
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _student = _args[AppStrings.STUDENT];
    _updateStudentInDb = _args[AppStrings.FUNCTION];
    _person = _student.person.target!;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _student.introduceYourself(),
          ),
        ),
        body: _content());
  }

  Widget _content() {
    return Column(
      children: [
        _name = TextFieldTemplate(label: AppStrings.NAME, hint: _person.name),
        _surname = TextFieldTemplate(
          label: AppStrings.SURNAME,
          hint: _person.surname,
        ),
        _age = TextFieldTemplateNum(
            label: AppStrings.AGE, hint: _student.age.toString()),
        Center(
          child: TextButton(
            onPressed: confirmEditChanges,
            child: const Text(AppStrings.OK),
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
    if (int.tryParse(_age.input ) == 0) {
      return false;
    }
    if (int.parse(_age.input ) > 0) {
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
            '${AppStrings.SUCCESFULLY_UPDATED_STUDENT} ${_student.introduceYourself()}');
    Navigator.pop(context);
  }
}
