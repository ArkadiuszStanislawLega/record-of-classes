import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

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

  String _personAge = '', _personName = '', _personSurname = '';

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
        TextField(
          decoration: InputDecoration(
            hintText: _person.name == '' ? AppStrings.NAME : _person.name,
          ),
          onChanged: (userInput) {
            _personName = userInput;
          },
        ),
        TextField(
          decoration: InputDecoration(
            hintText:
                _person.surname == '' ? AppStrings.SURNAME : _person.surname,
          ),
          onChanged: (userInput) {
            _personSurname = userInput;
          },
        ),
        TextField(
            onChanged: (userInput) {
              _personAge = userInput;
            },
            decoration: InputDecoration(
              hintText:
                  _student.age == 0 ? AppStrings.AGE : _student.age.toString(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ]),
        Center(
          child: TextButton(
            onPressed: confirmEditChanges,
            child: const Text(AppStrings.OK),
          ),
        ),
      ],
    );
  }

  bool _isNameValid() => _personName != '';

  bool _isSurnameValid() => _personSurname != '';

  bool _isAgeValid() {
    if (_personAge == '') {
      return false;
    }
    if (int.tryParse(_personAge) == 0) {
      return false;
    }
    if (int.parse(_personAge) > 0) {
      return true;
    }

    return false;
  }

  void confirmEditChanges() {
    _updateStudentInDb(
        name: _isNameValid() ? _personName : _person.name,
        surname: _isSurnameValid() ? _personSurname : _person.surname,
        age: _isAgeValid() ? int.parse(_personAge) : _student.age);
    SnackBarInfoTemplate(
        context: context,
        message:
            '${AppStrings.SUCCESFULLY_UPDATED_STUDENT} ${_student.introduceYourself()}');
    Navigator.pop(context);
  }
}
