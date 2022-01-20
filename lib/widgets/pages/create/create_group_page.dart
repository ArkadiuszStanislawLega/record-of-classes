import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/widgets/templates/create/create_group_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late ClassesType _classesType;
  final CreateGroupTemplate _createGroupTemplate = CreateGroupTemplate();

  @override
  Widget build(BuildContext context) {
    _classesType = ModalRoute.of(context)!.settings.arguments as ClassesType;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_classesType.name} - ${Strings.ADD_GROUP}'),
      ),
      body: Column(
        children: [
          _createGroupTemplate,
          TextButton(
            onPressed: _addToDatabase,
            child: const Text(Strings.ADD_GROUP),
          ),
        ],
      ),
    );
  }

  void _addToDatabase() {
    setState(() {
      if (_createGroupTemplate.isInputValuesAreValid()) {
        var group = _createGroupTemplate.getGroup();
        _classesType.groups.add(group);
        objectBox.store.box<ClassesType>().put(_classesType);
        _createGroupTemplate.clearFields();
      }
    });

    SnackBarInfoTemplate(
        context: context,
        message: '${Strings.SUCCESFULLY_ADDED} ${Strings.NEW_GROUP}');

    Navigator.pop(context);
  }
}
