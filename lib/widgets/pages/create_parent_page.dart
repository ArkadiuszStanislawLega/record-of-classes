import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/create_parent_template.dart';
import 'package:record_of_classes/widgets/templates/create_phone_template.dart';
import 'package:record_of_classes/widgets/templates/parent_list_template.dart';

class CreateParentPage extends StatefulWidget {
  const CreateParentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateParentPage();
  }
}

class _CreateParentPage extends State<CreateParentPage> {
  late Student _student;
  final Store _store = objectBox.store;
  final _createParentTemplate = CreateParentTemplate();
  final _createPhone = CreatePhoneTemplate();

  @override
  Widget build(BuildContext context) {
    _student = ModalRoute.of(context)!.settings.arguments as Student;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${Strings.ADD_PARENT} ${_student.person.target!.surname} ${_student.person.target!.name} '),
      ),
      body: Column(
        children: [
          _createParentTemplate,
          _createPhone,
          TextButton(
              onPressed: () {
                _createParent()
                    ? _createParentSuccessfulMessage()
                    : _createParentUnsuccessfulMessage();
              },
              child: const Text(Strings.ADD_PARENT)),
          ParentListTemplate(
            children: _student,
          ),
        ],
      ),
    );
  }

  bool _createParent() {
    var person = _createParentTemplate.getParent();
    var parent = Parent()..person.target = person;
    var phone = _createPhone.getPhone();

    if (_validateInputValues(person: person, phone: phone)) {
      _addToDatabase(parent: parent, person: person, phone: phone);
      return true;
    }
    return false;
  }

  bool _validateInputValues({required Person person, required Phone phone}) =>
      _validatePerson(person) && _validatePhone(phone);

  bool _validatePerson(Person person) =>
      person.name != '' && person.surname != '';

  bool _validatePhone(Phone phone) =>
      phone.numberName != '' && phone.number >= 0;

  void _addToDatabase(
      {required Parent parent, required Person person, required Phone phone}) {
    parent.phone.add(phone);
    parent.person.target = person;
    parent.children.add(_student);
    _student.parents.add(parent);

    _store.box<Student>().put(_student);
  }

  void _createParentSuccessfulMessage() {
    var parent = _createParentTemplate.getParent();
    _snackBarInfo(
        '${Strings.SUCCESFULLY_ADDED} ${parent.surname} ${parent.surname} ${Strings.TO_DATABASE}.');
  }

  void _createParentUnsuccessfulMessage() =>
      _snackBarInfo(Strings.FAIL_TO_ADD_NEW_PARENT_TO_DATABASE);

  void _snackBarInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
        width: 280.0,
        // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
