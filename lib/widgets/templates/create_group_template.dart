import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/create_address_template.dart';

class CreateGroupTemplate extends StatefulWidget {
  CreateGroupTemplate({Key? key, this.group}) : super(key: key);

  Group? group;

  String _inputName = '';

  late CreateAddressTemplate _createAddressTemplate;

  final TextEditingController _nameController = TextEditingController();

  void clearFields() {
    _inputName = '';
    _nameController.clear();
  }

  Group getAddress() {
    return Group()
      ..name = _inputName
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
        TextField(
          controller: widget._nameController,
          decoration: InputDecoration(
              hintText: widget.group == null
                  ? Strings.GROUP_NAME
                  : widget.group!.name),
          onChanged: (String str) =>
              str.isNotEmpty ? widget._inputName = str : {},
        ),
        widget._createAddressTemplate,
        TextButton(onPressed: (){}, child: const Text(Strings.ADD_GROUP))
      ],
    );
  }

  @override
  void initState() {
    widget._createAddressTemplate =
        CreateAddressTemplate(address: widget.group?.address.target);
    super.initState();
  }
}
