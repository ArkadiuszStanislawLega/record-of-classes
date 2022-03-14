import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/widgets/templates/text_fields/text_field_template.dart';

class CreateParentTemplate extends StatefulWidget {
  CreateParentTemplate({Key? key}) : super(key: key);

  late TextFieldTemplate _parentName, _parentSurname;

  Person getParent() {
    return Person(name: _parentName.input, surname: _parentSurname.input);
  }

  void clearValues() {
    _parentName.clear();
    _parentSurname.clear();
  }

  @override
  State<StatefulWidget> createState() {
    return _CreateParentTemplate();
  }
}

class _CreateParentTemplate extends State<CreateParentTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          widget._parentName =
              TextFieldTemplate(label: AppStrings.name, hint: ''),
          widget._parentSurname =
              TextFieldTemplate(label: AppStrings.surname, hint: '')
        ],
      ),
    );
  }
}
