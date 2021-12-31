import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/accounts_list_template.dart';
import 'package:record_of_classes/widgets/templates/parent_list_template.dart';

class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentDetailPage();
  }
}

class _StudentDetailPage extends State<StudentDetailPage> {
  late Student _student;
  late Person _person;
  late bool _isEdited = false;
  String _personAge = '', _personName = '', _personSurname = '';

  @override
  Widget build(BuildContext context) {
    _student = ModalRoute.of(context)!.settings.arguments as Student;
    _person = _student.person.target as Person;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_person.name}  ${_person.surname}'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: _isEdited ? editModeEnabled() : editModeDisabled(),
        ),
      ),
    );
  }

  List<Widget> editModeDisabled(){
    return [
      TextButton(
        onPressed: enableEditMode,
        child: const Text(Strings.EDIT),
      ),
      Text('${Strings.AGE}: ${_student.age.toString()}'),
      ParentListTemplate(),
      AccountListTemplate(account: _student.account)
    ];
  }

  List<Widget> editModeEnabled(){
    return [ TextField(
      decoration: InputDecoration(
        hintText:
        _person.name == '' ? Strings.NAME : _person.name,
      ),
      onChanged: (userInput) {
        _personName = userInput;
      },
    ),
      TextField(
        decoration: InputDecoration(
          hintText: _person.surname == ''
              ? Strings.SURNAME
              : _person.surname,
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
            hintText: _student.age == 0
                ? Strings.AGE
                : _student.age.toString(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ]),
      Center(
        child: Row(children: [
          TextButton(
            onPressed: confirmEditChanges,
            child: const Text(Strings.OK),
          ),
          TextButton(
            onPressed: cancelEditChanges,
            child: const Text(Strings.CANCEL),
          )
        ]),
      ),
    ];
  }

  void cancelEditChanges() {
    _personAge = '';
    _personName = '';
    _personSurname = '';

    disableEditMode();
  }

  void confirmEditChanges() {
    setNewValues();
    updateValueInDatabase();
    disableEditMode();
  }

  void setNewValues() {
    if (_personName != '') {
      _student.person.target!.name = _personName;
    }
    if (_personSurname != '') {
      _student.person.target!.surname = _personSurname;
    }
    if (_personAge != '') {
      _student.age = int.parse(_personAge);
    }
  }

  void updateValueInDatabase() => objectBox.store.box<Person>().put(_person);
  void enableEditMode() => setState(() => _isEdited = true);
  void disableEditMode() => setState(() => _isEdited = false);
}
