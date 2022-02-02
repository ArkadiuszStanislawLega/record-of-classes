import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/enumerators/PersonType.dart';
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
        title: const Text(AppStrings.ADD_PARENT),
      ),
      body: Column(
        children: [
          _createParentTemplate,
          _createPhone,
          TextButton(
              onPressed: () => _createParent(context),
              child: const Text(AppStrings.ADD_PARENT))
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
    _setPersonsValues();
    _connectPhoneWithOwner();
    _connectParentAndChildren();
    _pushChangesToDb();
  }

  void _addPhoneOwner() =>
      _inputPhone.owner.target = _inputParent.person.target;

  void _addPhoneToParent() =>
      _inputParent.person.target!.phones.add(_inputPhone);

  void _setPersonType() =>
      _inputParent.person.target!.dbPersonType = PersonType.parent.index;

  void _addChildrenToParent() => _inputParent.children.add(_selectedStudent);

  void _addParentToPerson() =>
      _inputParent.person.target!.parent.target = _inputParent;

  void _addParentToChildren() => _selectedStudent.parents.add(_inputParent);

  void _pushChangesToDb() => _store.box<Student>().put(_selectedStudent);

  void _setPersonsValues() {
    _setPersonType();
    _addParentToPerson();
  }

  void _connectPhoneWithOwner() {
    _addPhoneOwner();
    _addPhoneToParent();
  }

  void _connectParentAndChildren() {
    _addChildrenToParent();
    _addParentToChildren();
  }

  void _createParentSuccessfulMessage(BuildContext context) {
    var parent = _createParentTemplate.getParent();
    _snackBarInfo(context,
        '${AppStrings.SUCCESFULLY_ADDED} ${parent.surname} ${parent.surname} ${AppStrings.TO_DATABASE}.');
  }

  void _clearValues() {
    _createParentTemplate.clearValues();
    _createPhone.clearValues();
  }

  void _createParentUnsuccessfulMessage(BuildContext context) =>
      _snackBarInfo(context, AppStrings.FAIL_TO_ADD_NEW_PARENT_TO_DATABASE);

  void _snackBarInfo(BuildContext context, String message) {
    SnackBarInfoTemplate(message: message, context: context);
  }

  void _createParent(BuildContext context) {
    _getInputValues();
    _isInputValuesAreValid()
        ? {
            _addToDatabase(),
            _createParentSuccessfulMessage(context),
            _clearValues()
          }
        : _createParentUnsuccessfulMessage(context);
    Navigator.pop(context);
  }
}
