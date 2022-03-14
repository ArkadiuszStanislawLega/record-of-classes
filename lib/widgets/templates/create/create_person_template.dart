import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/widgets/templates/text_field_template.dart';

class CreatePersonTemplate extends StatelessWidget {
  late TextFieldTemplate _personName, _personSurname;

  CreatePersonTemplate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _personName = TextFieldTemplate(
          label: AppStrings.name,
          hint: '',
        ),
        _personSurname = TextFieldTemplate(label: AppStrings.surname, hint: '')
      ],
    );
  }

  void clearTemplate() async {
    _personName.clear();
    _personSurname.clear();
  }

  Person getPerson() {
    return Person(name: _personName.input, surname: _personSurname.input);
  }
}
