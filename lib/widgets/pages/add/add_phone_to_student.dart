import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
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
    _student = _args[AppStrings.student];
    _addContactFunction = _args[AppStrings.function];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.addContact,
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: Column(
        children: [
          _createPhoneTemplate,
          TextButton(
              onPressed: () => _addNewContactToDatabase(context),
              child: const Text(AppStrings.add))
        ],
      ),
    );
  }

  void _addNewContactToDatabase(BuildContext context) {
    // Phone phone = _createPhoneTemplate.getPhone();
    // phone.owner.target = _student.person.target;
    // _student.person.target!.phones.add(phone);
    // objectBox.store.box<Phone>().put(phone);
    // objectBox.store.box<Person>().put(_student.person.target!);
    _addContactFunction(_createPhoneTemplate.getPhone());
    SnackBarInfoTemplate(
        context: context,
        message:
            '${AppStrings.addNewContact}: ${_student.introduceYourself()}');
    Navigator.pop(context);
  }
}
