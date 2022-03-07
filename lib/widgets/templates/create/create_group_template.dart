import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/create/create_address_template.dart';
import 'package:record_of_classes/widgets/templates/text_field_template.dart';

class CreateGroupTemplate extends StatefulWidget {
  CreateGroupTemplate({Key? key, this.group, required this.classesTypeName})
      : super(key: key){
    _createAddressTemplate =
        CreateAddressTemplate(address: group?.address.target);
    _inputName = TextFieldTemplate(
        label: AppStrings.GROUP_NAME,
        hint: group == null ? '' : group!.name);

    _inputName.controller!.text = classesTypeName;
  }

  Group? group;

  String classesTypeName = '';

  CreateAddressTemplate _createAddressTemplate = CreateAddressTemplate();
  late TextFieldTemplate _inputName;

  void clearFields() {
    _inputName.clear();
    _createAddressTemplate.clearFields();
  }

  bool isInputValuesAreValid() {
    return _inputName.userInput != '';
  }

  Group getGroup() {
    return Group()
      ..name = _inputName.input
      ..address.target = _createAddressTemplate.getAddress();
  }

  @override
  _CreateGroupTemplateState createState() => _CreateGroupTemplateState();
}

class _CreateGroupTemplateState extends State<CreateGroupTemplate> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget._inputName,
        widget._createAddressTemplate,
      ],
    );
  }
}
