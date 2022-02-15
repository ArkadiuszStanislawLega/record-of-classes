import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/widgets/templates/text_field_template.dart';
import 'package:record_of_classes/widgets/templates/text_field_template_num.dart';

class CreatePhoneTemplate extends StatefulWidget {
  CreatePhoneTemplate({Key? key, this.phone}) : super(key: key);
  Phone? phone;

  late TextFieldTemplate _numberName;
  late TextFieldTemplateNum _number;

  Phone getPhone() {
    try {
      if (phone == null) {
        return Phone(
            numberName: _numberName.userInput, number: int.parse(_number.input));
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
    if (phone!.number != int.parse(_number.userInput) &&
        _number.userInput != '') {
      phone!.number = int.parse(_number.userInput);
    }
  }

  bool isEditedInputValid() =>
      _isEditedPhoneNameValid() && _isEditedPhoneNumberValid();

  bool _isEditedPhoneNameValid() =>
      phone!.numberName != _numberName.userInput && _isPhoneNameValid();

  bool _isEditedPhoneNumberValid() {
    try {
      int number = int.parse(_number.userInput);
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

  bool _isPhoneNumberValid() =>
      _number.userInput != '' && int.parse(_number.userInput) > 0;

  void clearValues() {
    _number.clear();
    _numberName.clear();
  }

  @override
  State<StatefulWidget> createState() {
    return _CreatePhoneTemplate();
  }
}

class _CreatePhoneTemplate extends State<CreatePhoneTemplate> {
  @override
  void initState() {
    widget._numberName = TextFieldTemplate(
        label: AppStrings.PHONE_NAME,
        hint: widget.phone == null ? '' : widget.phone!.numberName);
    widget._number = TextFieldTemplateNum(
        label: AppStrings.PHONE_NUMBER,
        hint: widget.phone == null ? '' : widget.phone!.number.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Column(
        children: [widget._numberName, widget._number],
      ),
    );
  }
}
