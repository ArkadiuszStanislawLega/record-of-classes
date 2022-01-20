import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/widgets/templates/create/create_phone_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class EditPhonePage extends StatefulWidget {
  EditPhonePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditPhonePage();
  }
}

class _EditPhonePage extends State<EditPhonePage> {
  late Phone _phone;
  late CreatePhoneTemplate _createPhoneTemplate;

  @override
  Widget build(BuildContext context) {
    _phone = ModalRoute.of(context)!.settings.arguments as Phone;
    _createPhoneTemplate = CreatePhoneTemplate(
      phone: _phone,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('${Strings.EDIT} ${Strings.CONTACT.toLowerCase()}'),
      ),
      body: Column(
        children: [
          _createPhoneTemplate,
          TextButton(
            onPressed: () => _actionAfterConfirmButtonClick(context),
            child: const Text(Strings.OK),
          )
        ],
      ),
    );
  }

  void _actionAfterConfirmButtonClick(BuildContext context) {
    if (_createPhoneTemplate.isEditedInputValid()) {
      setState(() {
        _phone = _createPhoneTemplate.getPhone();
        objectBox.store.box<Phone>().put(_phone);
      });

      SnackBarInfoTemplate(
          context: context,
          message:
              '${Strings.EDITED} ${Strings.CONTACT.toLowerCase()}: ${_createPhoneTemplate.getPhone().owner.target!.introduceYourself()}');
      Navigator.pop(context);
    } else {
      SnackBarInfoTemplate(
          context: context, message: Strings.ERROR_MESSAGE_CHECK_FIELDS_FILL);
    }
  }
}
