import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/teacher.dart';
import 'package:record_of_classes/widgets/templates/add_new_classes_type_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class CreateClassesTypePage extends StatelessWidget {
  CreateClassesTypePage({Key? key}) : super(key: key);
  final AddNewClassesTypeTemplate _addNewClassesTypeTemplate =
      AddNewClassesTypeTemplate();

  late ClassesType _createdClassType;
  late Function? _createFunction;
  Map _args = {};

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _createFunction = _args[AppStrings.function];

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addClassesType),
      ),
      body: Column(
        children: [
          _addNewClassesTypeTemplate,
          TextButton(
            onPressed: () => _confirmButtonOnClickActions(context),
            child: const Text(AppStrings.addClassesType),
          ),
        ],
      ),
    );
  }

  void _confirmButtonOnClickActions(BuildContext context) {
    if (_addNewClassesTypeTemplate.isInputValid()) {
      _createdClassType = _addNewClassesTypeTemplate.getClassType();
      _createdClassType.teacher.target = _getTeacherFromDb();
      // _createdClassType.addToDb();
      _createFunction!(_createdClassType);

      SnackBarInfoTemplate(
          context: context,
          message:
              '${AppStrings.createdNewClassesType}: ${_createdClassType.name}');
      Navigator.pop(context);
    } else {
      SnackBarInfoTemplate(
          context: context, message: AppStrings.errorMessageCheckFieldFill);
    }
  }

  Teacher _getTeacherFromDb() =>
      ObjectBox.store.box<Teacher>().getAll().elementAt(0);

}
