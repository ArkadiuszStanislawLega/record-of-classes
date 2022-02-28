import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
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
  late Function? _addFunction;
  late CreateGroupTemplate _createGroupTemplate;
  Map _args = {};

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _classesType = _args[AppStrings.CLASSES_TYPE];
    _addFunction = _args[AppStrings.FUNCTION];
    _createGroupTemplate = CreateGroupTemplate(classesTypeName: _classesType.name);
    return Scaffold(
      appBar: AppBar(
        title: Text('${_classesType.name} - ${AppStrings.ADD_GROUP}'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _createGroupTemplate,
            TextButton(
              onPressed: _addToDatabase,
              child: const Text(AppStrings.ADD_GROUP),
            ),
          ],
        ),
      ),
    );
  }

  void _addToDatabase() {
    if (_addFunction == null) {
      setState(() {
        if (_createGroupTemplate.isInputValuesAreValid()) {
          _classesType.addGroup(_createGroupTemplate.getGroup());
          _createGroupTemplate.clearFields();
        }
      });
    } else {
      var groupCreated = _createGroupTemplate.getGroup();
      groupCreated.classesType.target = _classesType;
      _addFunction!(groupCreated);
      _createGroupTemplate.clearFields();
    }

    SnackBarInfoTemplate(
        context: context,
        message: '${AppStrings.SUCCESFULLY_ADDED} ${AppStrings.NEW_GROUP}');

    Navigator.pop(context);
  }
}
