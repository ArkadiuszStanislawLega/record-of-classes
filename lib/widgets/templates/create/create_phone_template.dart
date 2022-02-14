import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/widgets/templates/text_field_template.dart';

class CreatePhoneTemplate extends StatefulWidget {
  CreatePhoneTemplate({Key? key, this.phone}) : super(key: key);
  Phone? phone;
  String _number = '';

  late TextFieldTemplate _numberName;
  final TextEditingController _numberInputController = TextEditingController();

  Phone getPhone() {
    try {
      if (phone == null) {
        return Phone(numberName: _numberName.userInput, number: int.parse(_number));
      }
      _checkInput();
      return phone!;
    } on FormatException {
      return Phone(numberName: _numberName.userInput, number: 0);
    }
  }

  void _checkInput() {
    _checkIfNumberNameIsChange();
    _checkIfPhoneNumberIsChange();
  }

  void _checkIfNumberNameIsChange() {
    if (phone!.numberName != _numberName.userInput && _isPhoneNameValid()) {
      phone!.numberName = _numberName.userInput;
    }
  }

  void _checkIfPhoneNumberIsChange() {
    if (phone!.number != int.parse(_number) && _number != '') {
      phone!.number = int.parse(_number);
    }
  }

  bool isEditedInputValid() =>
      _isEditedPhoneNameValid() && _isEditedPhoneNumberValid();

  bool _isEditedPhoneNameValid() =>
      phone!.numberName != _numberName.userInput && _isPhoneNameValid();

  bool _isEditedPhoneNumberValid() {
    try {
      int number = int.parse(_number);
      return phone!.number != number && number > 0;
    } on FormatException {
      return false;
    }
  }

  bool isInputValid() {
    try {
      if (_isPhoneNameValid() && _isPhoneNumberValid()) {
        return true;
      }
      return false;
    } on FormatException {
      return false;
    }
  }

  bool _isPhoneNameValid() => _numberName.userInput != '';

  bool _isPhoneNumberValid() => _number != '' && int.parse(_number) > 0;

  void clearValues() {
    _number = '';
    _numberInputController.clear();
    _numberName.clear();
  }

  @override
  State<StatefulWidget> createState() {
    return _CreatePhoneTemplate();
  }
}

class _CreatePhoneTemplate extends State<CreatePhoneTemplate> {
  @override
  Widget build(BuildContext context) {
    widget._numberName =    TextFieldTemplate(
        label: AppStrings.PHONE_NAME,
        hint: widget.phone == null ? '' : widget.phone!.numberName);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Column(
        children: [
          widget._numberName,
          TextField(
            style: Theme.of(context).textTheme.headline2,
              controller: widget._numberInputController,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                label: Text(
                  widget.phone == null
                      ? AppStrings.PHONE_NUMBER
                      : widget.phone!.number.toString(),
                  style: Theme.of(context).textTheme.headline2,
                ),
                // hintText:
              ),
              onChanged: (userInput) => widget._number = userInput),
        ],
      ),
    );
  }
}
