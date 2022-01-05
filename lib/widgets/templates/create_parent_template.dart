import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/person.dart';

class CreateParentTemplate extends StatefulWidget {
  CreateParentTemplate({Key? key}) : super(key: key);

  String _parentName = '', _parentSurname = '';
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _surnameInputController = TextEditingController();

  Person getParent() {
    return Person(name: _parentName, surname: _parentSurname);
  }

  void clearValues() {
    _parentName = '';
    _parentSurname = '';
    _nameInputController.clear();
    _surnameInputController.clear();
  }

  @override
  State<StatefulWidget> createState() {
    return _CreateParentTemplate();
  }
}

class _CreateParentTemplate extends State<CreateParentTemplate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
            controller: widget._nameInputController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.NAME,
            ),
            onChanged: (userInput) => widget._parentName = userInput),
        TextField(
            controller: widget._surnameInputController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.SURNAME,
            ),
            onChanged: (userInput) => widget._parentSurname = userInput),
      ],
    );
  }
}
