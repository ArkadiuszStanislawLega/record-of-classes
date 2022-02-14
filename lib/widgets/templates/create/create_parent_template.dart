import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/person.dart';

class CreateParentTemplate extends StatefulWidget {
  CreateParentTemplate({Key? key}) : super(key: key);

  String _parentName = '', _parentSurname = '';
  final TextEditingController _nameInputController = TextEditingController(),
      _surnameInputController = TextEditingController();

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
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(AppStrings.NAME,
                  style: Theme.of(context).textTheme.headline2),
            ),
            onChanged: (userInput) => widget._parentName = userInput),
        TextField(
            controller: widget._surnameInputController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              label: Text(AppStrings.SURNAME,
                  style: Theme.of(context).textTheme.headline2),
            ),
            onChanged: (userInput) => widget._parentSurname = userInput),
      ],
    );
  }
}
