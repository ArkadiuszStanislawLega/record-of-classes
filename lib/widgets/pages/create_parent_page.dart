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
  late Person _inputPerson;
  late Parent _inputParent;
  late Phone _inputPhone;
  late Student _selectedStudent;
  final Store _store = objectBox.store;
  final _createParentTemplate = CreateParentTemplate();
  final _createPhone = CreatePhoneTemplate();

  @override
  Widget build(BuildContext context) {
    _selectedStudent = ModalRoute.of(context)!.settings.arguments as Student;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${Strings.ADD_PARENT} ${_selectedStudent.person.target!.surname} ${_selectedStudent.person.target!.name} '),
      ),
      body: Column(
        children: [
          _createParentTemplate,
          _createPhone,
          TextButton(
              onPressed: () => {
                    _getInputValues(),
                    _isInputValuesAreValid()
                        ? {
                            _addToDatabase(),
                            _createParentSuccessfulMessage(),
                            _clearValues()
                          }
                        : _createParentUnsuccessfulMessage(),
                  },
              child: const Text(Strings.ADD_PARENT)),
          ParentListTemplate(
            children: _selectedStudent,
          ),
        ],
      ),
    );
  }

  void _getInputValues() {
    _inputPerson = _createParentTemplate.getParent();
    _inputParent = Parent()..person.target = _inputPerson;
    _inputPhone = _createPhone.getPhone();
  }

  bool _isInputValuesAreValid() => _isPersonValidated() && _isPhoneValidated();

  bool _isPersonValidated() =>
      _inputPerson.name != '' && _inputPerson.surname != '';

  bool _isPhoneValidated() =>
      _inputPhone.numberName != '' && _inputPhone.number > 0;

  void _addToDatabase() {
    _inputParent.phone.add(_inputPhone);
    _inputParent.children.add(_selectedStudent);
    _selectedStudent.parents.add(_inputParent);

    _store.box<Student>().put(_selectedStudent);
  }

  void _createParentSuccessfulMessage() {
    var parent = _createParentTemplate.getParent();
    _snackBarInfo(
        '${Strings.SUCCESFULLY_ADDED} ${parent.surname} ${parent.surname} ${Strings.TO_DATABASE}.');
  }

  void _clearValues(){
    _createParentTemplate.clearValues();
    _createPhone.clearValues();
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
