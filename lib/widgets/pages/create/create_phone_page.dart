import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/widgets/templates/create/create_phone_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class CreatePhonePage extends StatefulWidget {
  CreatePhonePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreatePhonePage();
  }
}

class _CreatePhonePage extends State<CreatePhonePage> {
  late Parent _parent;

  final CreatePhoneTemplate _createPhoneTemplate = CreatePhoneTemplate();

  @override
  Widget build(BuildContext context) {
    _parent = ModalRoute.of(context)!.settings.arguments as Parent;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.CREATE_CONTACT),
      ),
      body: Column(
        children: [
          _createPhoneTemplate,
          TextButton(
            onPressed: () => _actionAfterClickAddButton(context),
            child: const Text(Strings.ADD),
          ),
        ],
      ),
    );
  }

  void _actionAfterClickAddButton(BuildContext context) {
    _updateDatabase();
    SnackBarInfoTemplate(
        context: context,
        message:
            '${Strings.ADDED_NEW_CONTACT} ${Strings.TO} ${_parent.introduceYourself()}');
    Navigator.pop(context);
  }

  void _updateDatabase() {
    setState(() {
      Phone phone = _createPhoneTemplate.getPhone();
      phone.owner.target = _parent.person.target!;
      _parent.person.target!.phones.add(phone);
      objectBox.store.box<Parent>().put(_parent);
    });
  }
}
