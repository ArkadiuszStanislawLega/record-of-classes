import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/person.dart';

class CreatePersonTemplate extends StatelessWidget {
  String _personName = '', _personSurname = '';
  final TextEditingController _nameController= TextEditingController(),
  _surnameController = TextEditingController();
  CreatePersonTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: AppStrings.NAME,
            ),
            onChanged: (userInput) => _personName = userInput),
        TextField(
          controller: _surnameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: AppStrings.SURNAME,
            ),
            onChanged: (userInput) => _personSurname = userInput),
      ],
    );
  }

  void clearTemplate() async {
    _personName = '';
    _personSurname = '';
    _surnameController.clear();
    _nameController.clear();
  }

  Person getPerson() {
    return Person(name: _personName, surname: _personSurname);
  }
}
