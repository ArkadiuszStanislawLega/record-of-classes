import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/person.dart';

class CreateParentTemplate extends StatelessWidget {
  String _parentName = '', _parentSurname = '';

  CreateParentTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.NAME,
            ),
            onChanged: (userInput) => _parentName = userInput
        ),
        TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.SURNAME,
            ),
            onChanged: (userInput) => _parentSurname = userInput
        ),
      ],
    );
  }

  Parent getParent(){
    Person person = Person(name:_parentName, surname:_parentSurname);
    return Parent()
        ..person.target = person;
  }
}
