import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/address.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/create/create_group_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage({Key? key}) : super(key: key);

  @override
  _EditGroupPageState createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  late Group _group;
  late CreateGroupTemplate _createGroupTemplate;

  @override
  Widget build(BuildContext context) {
    _group = ModalRoute.of(context)!.settings.arguments as Group;
    _createGroupTemplate = CreateGroupTemplate(group: _group);
    return Scaffold(
      appBar: AppBar(
        title: Text('${Strings.EDIT} ${_group.name}'),
      ),
      body: Column(
        children: [
          _createGroupTemplate,
          TextButton(
            onPressed: _createGroupButtonOnClickActions,
            child: const Text(Strings.OK),
          ),
        ],
      ),
    );
  }

  void _createGroupButtonOnClickActions() {
      _checkValues();
      _updateDatabase();

    SnackBarInfoTemplate(
        context: context,
        message: '${Strings.DATA_HAS_BEEN_UPDATED} ${_group.name}');
    Navigator.pop(context);
  }

  void _checkValues(){
    Group createdGroup = _createGroupTemplate.getGroup();
    Address createdGroupAddress = createdGroup.address.target!;

    setState(() {
      if (_group.name != createdGroup.name && createdGroup.name != '') {
        _group.name = createdGroup.name;
      }

      if (_group.address.target!.city != createdGroupAddress.city && createdGroupAddress.city != '') {
        _group.address.target!.city = createdGroupAddress.city;
      }

      if (_group.address.target!.street != createdGroupAddress.street &&
          createdGroupAddress.street != '') {
        _group.address.target!.street = createdGroupAddress.street;
      }

      if (_group.address.target!.houseNumber != createdGroupAddress.houseNumber) {
        _group.address.target!.houseNumber = createdGroupAddress.houseNumber;
      }

      if (_group.address.target!.flatNumber != createdGroupAddress.flatNumber) {
        _group.address.target!.flatNumber = createdGroupAddress.flatNumber;
      }
    });
  }

  void _updateDatabase(){
    objectBox.store.box<Group>().put(_group);
    objectBox.store.box<Address>().put(_group.address.target!);
  }
}
