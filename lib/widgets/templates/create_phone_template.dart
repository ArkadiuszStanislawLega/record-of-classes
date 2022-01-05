import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/phone.dart';

class CreatePhoneTemplate extends StatelessWidget{
  String _number = '', _numberName = '';

  CreatePhoneTemplate({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.PHONE_NAME,
            ),
            onChanged: (userInput) => _numberName = userInput
        ),
        TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.PHONE_NUMBER,
            ),
            onChanged: (userInput) => _number = userInput
        ),
      ],
    );
  }

  Phone getPhone(){
    try {
      return Phone(numberName: _numberName, number: int.parse(_number));
    } on FormatException{
      return Phone(numberName: _numberName, number: 0);
    }
  }
}