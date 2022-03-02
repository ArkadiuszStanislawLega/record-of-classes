import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/create/create_address_template.dart';
import 'package:record_of_classes/widgets/templates/text_field_template.dart';

class CreateGroupTemplate extends StatefulWidget {
  CreateGroupTemplate({Key? key, this.group, required this.classesTypeName})
      : super(key: key);

  Group? group;

  String classesTypeName = '';

  CreateAddressTemplate _createAddressTemplate = CreateAddressTemplate();
  late TextFieldTemplate _inputName  = TextFieldTemplate(label: AppStrings.GROUP_NAME, hint: '');

  void clearFields() {
    _inputName.clear();
    _createAddressTemplate.clearFields();
  }

  bool isInputValuesAreValid() {
    return _inputName.userInput != '';
  }

  Group getGroup() {
    return Group()
      ..name = _inputName.userInput
      ..address.target = _createAddressTemplate.getAddress();
  }

  @override
  _CreateGroupTemplateState createState() => _CreateGroupTemplateState();
}

class _CreateGroupTemplateState extends State<CreateGroupTemplate> {
  @override
  void initState() {
    widget._createAddressTemplate =
        CreateAddressTemplate(address: widget.group?.address.target);
    widget._inputName = TextFieldTemplate(
        label: AppStrings.GROUP_NAME,
        hint: widget.group == null ? '' : widget.group!.name);
    widget._inputName.controller!.text = widget.classesTypeName;
    super.initState();
  }

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
