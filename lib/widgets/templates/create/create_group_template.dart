import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/create/create_address_template.dart';

class CreateGroupTemplate extends StatefulWidget {
  CreateGroupTemplate({Key? key, this.group, required this.classesTypeName})
      : super(key: key);

  Group? group;

  String _inputName = '', classesTypeName = '';

  CreateAddressTemplate _createAddressTemplate = CreateAddressTemplate();

  final TextEditingController _nameController = TextEditingController();

  void clearFields() {
    _inputName = '';
    _nameController.clear();
    _createAddressTemplate.clearFields();
  }

  bool isInputValuesAreValid() {
    return _inputName != '';
  }

  Group getGroup() {
    return Group()
      ..name = _inputName
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget._nameController.text = widget.classesTypeName;

    return Column(
      children: [
        TextField(
          controller: widget._nameController,
          decoration: InputDecoration(
              label: Text(AppStrings.GROUP_NAME,
                  style: Theme.of(context).textTheme.headline2),
              hintText: widget.group == null
                  ? AppStrings.GROUP_NAME
                  : widget.group!.name),
          onChanged: (String str) =>
              str.isNotEmpty ? widget._inputName = str : {},
        ),
        widget._createAddressTemplate,
      ],
    );
  }
}
