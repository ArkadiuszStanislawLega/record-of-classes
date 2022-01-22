import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
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

  String _personAge = '', _personName = '', _personSurname = '';

  @override
  Widget build(BuildContext context) {
    _student = ModalRoute.of(context)!.settings.arguments as Student;
    _person = _student.person.target!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _student.introduceYourself(),
        ),
      ),
      body: _content()
    );
  }

  Widget _content(){
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: _person.name == '' ? Strings.NAME : _person.name,
          ),
          onChanged: (userInput) {
            _personName = userInput;
          },
        ),
        TextField(
          decoration: InputDecoration(
            hintText:
            _person.surname == '' ? Strings.SURNAME : _person.surname,
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
              _student.age == 0 ? Strings.AGE : _student.age.toString(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ]),
        Center(
          child: TextButton(
            onPressed: confirmEditChanges,
            child: const Text(Strings.OK),
          ),
        ),
      ],
    );
  }

  void setNewValues() {
    setState(() {
      if (_personName != '') {
        _student.person.target!.name = _personName;
      }
      if (_personSurname != '') {
        _student.person.target!.surname = _personSurname;
      }
      if (_personAge != '') {
        _student.age = int.parse(_personAge);
      }
    });
  }

  void confirmEditChanges() {
    setNewValues();
    updateValueInDatabase();
    SnackBarInfoTemplate(
        context: context,
        message:
            '${Strings.SUCCESFULLY_UPDATED_STUDENT} ${_student.introduceYourself()}');
    Navigator.pop(context);
  }

  void updateValueInDatabase() =>
      setState(() => objectBox.store.box<Student>().put(_student));
}
