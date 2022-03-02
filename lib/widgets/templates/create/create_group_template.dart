import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/create/create_address_template.dart';
import 'package:record_of_classes/widgets/templates/text_field_template.dart';

class CreateGroupTemplate extends StatefulWidget {
  CreateGroupTemplate({Key? key, this.group, required this.classesTypeName})
      : super(key: key){
    _name = TextFieldTemplate(label: AppStrings.GROUP_NAME, hint: '${group?.name}');
  }

  Group? group;

  String classesTypeName = '';

  CreateAddressTemplate _createAddressTemplate = CreateAddressTemplate();
  late TextFieldTemplate _name;

  void clearFields() {
    _name.clear();
    _createAddressTemplate.clearFields();
  }

  bool isInputValuesAreValid() {
    return _name.userInput != '';
  }

  Group getGroup() {
    return Group()
      ..name = _name.userInput
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
    widget._name = TextFieldTemplate(
        label: AppStrings.GROUP_NAME,
        hint: widget.group == null ? '' : widget.group!.name);
    widget._name.controller!.text = widget.classesTypeName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget._name,
        widget._createAddressTemplate,
      ],
    );
  }
}
