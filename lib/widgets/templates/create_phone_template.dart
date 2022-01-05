import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/phone.dart';

class CreatePhoneTemplate extends StatefulWidget {
  CreatePhoneTemplate({Key? key}) : super(key: key);
  String _number = '', _numberName = '';

  final TextEditingController _numberInputController = TextEditingController(),
      _nameNumberInputController = TextEditingController();

  Phone getPhone() {
    try {
      return Phone(numberName: _numberName, number: int.parse(_number));
    } on FormatException {
      return Phone(numberName: _numberName, number: 0);
    }
  }

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
    return Column(
      children: [
        TextField(
            controller: widget._nameNumberInputController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.PHONE_NAME,
            ),
            onChanged: (userInput) => widget._numberName = userInput),
        TextField(
            controller: widget._numberInputController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.PHONE_NUMBER,
            ),
            onChanged: (userInput) => widget._number = userInput),
      ],
    );
  }
}
