import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/widgets/templates/create/create_phone_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class EditPhonePage extends StatelessWidget {
  EditPhonePage({Key? key}) : super(key: key);

  late Phone _phone;
  late CreatePhoneTemplate _createPhoneTemplate;
  late Map _args;
  late Function? _updateParentFunction;

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _phone = _args[AppStrings.PHONE_NUMBER];
    _updateParentFunction = _args[AppStrings.FUNCTION];

    _createPhoneTemplate = CreatePhoneTemplate(
      phone: _phone,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.EDIT} ${AppStrings.CONTACT.toLowerCase()}'),
      ),
      body: Column(
        children: [
          _createPhoneTemplate,
          TextButton(
            onPressed: () => _actionAfterConfirmButtonClick(context),
            child: const Text(AppStrings.OK),
          )
        ],
      ),
    );
  }

  void _actionAfterConfirmButtonClick(BuildContext context) {
    _updateModel();

    if (_updateParentFunction != null) {
      _updateParentFunction!(_phone);
    }



    SnackBarInfoTemplate(
        context: context,
        message:
            '${AppStrings.EDITED} ${AppStrings.CONTACT.toLowerCase()}: ${_phone.owner.target!.introduceYourself()}');
    Navigator.pop(context);
  }

  void _updateModel() {
    _phone.numberName = _createPhoneTemplate.isEditedPhoneNameValid()
        ? _createPhoneTemplate.getPhone().numberName
        : _phone.numberName;
    _phone.number = _createPhoneTemplate.isEditedPhoneNumberValid()
        ? _createPhoneTemplate.getPhone().number
        : _phone.number;
    _phone.addToDb();
  }
}
