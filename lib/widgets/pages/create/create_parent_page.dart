import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/create/create_parent_template.dart';
import 'package:record_of_classes/widgets/templates/create/create_phone_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class CreateParentPage extends StatelessWidget {
  CreateParentPage({Key? key}) : super(key: key);
  late Student _selectedStudent;
  late Person _inputPerson;
  late Parent _inputParent;
  late Phone _inputPhone;
  final Store _store = objectBox.store;

  final _createParentTemplate = CreateParentTemplate();
  final _createPhone = CreatePhoneTemplate();

  @override
  Widget build(BuildContext context) {
    _selectedStudent = ModalRoute.of(context)!.settings.arguments as Student;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.ADD_PARENT),
      ),
      body: Column(
        children: [
          _createParentTemplate,
          _createPhone,
          TextButton(
              onPressed: () => _createParent(context), child: const Text(Strings.ADD_PARENT))
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

  void _createParentSuccessfulMessage(BuildContext context) {
    var parent = _createParentTemplate.getParent();
    _snackBarInfo(context, '${Strings.SUCCESFULLY_ADDED} ${parent.surname} ${parent.surname} ${Strings.TO_DATABASE}.');
  }

  void _clearValues() {
    _createParentTemplate.clearValues();
    _createPhone.clearValues();
  }

  void _createParentUnsuccessfulMessage(BuildContext context) =>
      _snackBarInfo(context , Strings.FAIL_TO_ADD_NEW_PARENT_TO_DATABASE);

  void _snackBarInfo(BuildContext context, String message) {
    SnackBarInfoTemplate(message: message, context: context);
  }

  void _createParent(BuildContext context) {
    _getInputValues();
    _isInputValuesAreValid()
        ? {_addToDatabase(), _createParentSuccessfulMessage(context), _clearValues()}
        : _createParentUnsuccessfulMessage(context);
  }
}
