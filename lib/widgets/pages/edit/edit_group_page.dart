import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
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
  late Function? _update;
  late Map _args;

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _group = _args[AppStrings.GROUP];
    _update = _args[AppStrings.FUNCTION];

    _createGroupTemplate = CreateGroupTemplate(group: _group);
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.EDIT} ${_group.name}'),
      ),
      body: Column(
        children: [
          _createGroupTemplate,
          TextButton(
            onPressed: _createGroupButtonOnClickActions,
            child: const Text(AppStrings.OK),
          ),
        ],
      ),
    );
  }

  void _createGroupButtonOnClickActions() {
      if(_isSomeValuesAreChange()) {
        _updateDatabase();
        if(_update != null){
          _update!(_group);
        }

        SnackBarInfoTemplate(
            context: context,
            message: '${AppStrings.DATA_HAS_BEEN_UPDATED} ${_group.name}');
      }
    Navigator.pop(context);
  }

  bool _isSomeValuesAreChange(){
    bool isChange = false;
    Group createdGroup = _createGroupTemplate.getGroup();
    Address createdGroupAddress = createdGroup.address.target!;

    setState(() {
      if (_group.name != createdGroup.name && createdGroup.name != '') {
        _group.name = createdGroup.name;
        isChange = true;
      }

      if (_group.address.target!.city != createdGroupAddress.city && createdGroupAddress.city != '') {
        _group.address.target!.city = createdGroupAddress.city;
        isChange = true;
      }

      if (_group.address.target!.street != createdGroupAddress.street &&
          createdGroupAddress.street != '') {
        _group.address.target!.street = createdGroupAddress.street;
        isChange = true;
      }

      if (_group.address.target!.houseNumber != createdGroupAddress.houseNumber) {
        _group.address.target!.houseNumber = createdGroupAddress.houseNumber;
        isChange = true;
      }

      if (_group.address.target!.flatNumber != createdGroupAddress.flatNumber) {
        _group.address.target!.flatNumber = createdGroupAddress.flatNumber;
        isChange = true;
      }
    });
    return isChange;
  }

  void _updateDatabase(){
    _group.addToDb();
    _group.address.target!.addToDb();
  }
}
