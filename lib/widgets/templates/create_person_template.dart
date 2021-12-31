import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/person.dart';

class CreatePersonTemplate extends StatelessWidget {
  String _personName = '', _personSurname = '';

  CreatePersonTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.NAME,
            ),
            onChanged: (userInput) => _personName = userInput),
        TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.SURNAME,
            ),
            onChanged: (userInput) => _personSurname = userInput),
      ],
    );
  }

  Person getPerson() {
    return Person(name: _personName, surname: _personSurname);
  }
}
