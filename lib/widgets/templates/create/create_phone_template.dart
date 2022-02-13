import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/phone.dart';

class CreatePhoneTemplate extends StatefulWidget {
  CreatePhoneTemplate({Key? key, this.phone}) : super(key: key);
  Phone? phone;
  String _number = '', _numberName = '';

  final TextEditingController _numberInputController = TextEditingController(),
      _nameNumberInputController = TextEditingController();

  Phone getPhone() {
    try {
      if (phone == null) {
        return Phone(numberName: _numberName, number: int.parse(_number));
      }
      _checkInput();
      return phone!;
    } on FormatException {
      return Phone(numberName: _numberName, number: 0);
    }
  }

  void _checkInput() {
    _checkIfNumberNameIsChange();
    _checkIfPhoneNumberIsChange();
  }

  void _checkIfNumberNameIsChange() {
    if (phone!.numberName != _numberName && _isPhoneNameValid()) {
      phone!.numberName = _numberName;
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
      phone!.numberName != _numberName && _isPhoneNameValid();

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

  bool _isPhoneNameValid() => _numberName != '';

  bool _isPhoneNumberValid() => _number != '' && int.parse(_number) > 0;

  void clearValues() {
    _number = '';
    _numberName = '';
    _numberInputController.clear();
    _nameNumberInputController.clear();
  }

  @override
  State<StatefulWidget> createState() {
    return _CreatePhoneTemplate();
  }
}

class _CreatePhoneTemplate extends State<CreatePhoneTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          TextField(
              controller: widget._nameNumberInputController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: Text(
                  widget.phone == null
                      ? AppStrings.PHONE_NAME
                      : widget.phone!.numberName,
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              onChanged: (userInput) => widget._numberName = userInput),
          TextField(
              controller: widget._numberInputController,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
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
