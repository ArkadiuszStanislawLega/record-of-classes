import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/create/create_phone_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class AddPhoneToStudentPage extends StatelessWidget {
  AddPhoneToStudentPage({Key? key}) : super(key: key);
  late Student _student;
  late Function _addContactFunction;
  Map _args = {};
  final CreatePhoneTemplate _createPhoneTemplate = CreatePhoneTemplate();

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _student = _args[AppStrings.STUDENT];
    _addContactFunction = _args[AppStrings.FUNCTION];
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.ADD_CONTACT),
      ),
      body: Column(
        children: [
          _createPhoneTemplate,
          TextButton(onPressed: ()=> _addNewContactToDatabase(context), child: const Text(AppStrings.ADD))
        ],
      ),
    );
  }

  void _addNewContactToDatabase(BuildContext context){
    // Phone phone = _createPhoneTemplate.getPhone();
    // phone.owner.target = _student.person.target;
    // _student.person.target!.phones.add(phone);
    // objectBox.store.box<Phone>().put(phone);
    // objectBox.store.box<Person>().put(_student.person.target!);
    _addContactFunction(_createPhoneTemplate.getPhone());
    SnackBarInfoTemplate(context: context, message: '${AppStrings.ADDED_NEW_CONTACT}: ${_student.introduceYourself()}');
    Navigator.pop(context);
  }
}
