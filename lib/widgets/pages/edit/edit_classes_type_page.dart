import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/widgets/templates/add_new_classes_type_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class EditClassesTypePage extends StatefulWidget {
  const EditClassesTypePage({Key? key}) : super(key: key);

  @override
  _EditClassesTypePageState createState() => _EditClassesTypePageState();
}

class _EditClassesTypePageState extends State<EditClassesTypePage> {
  late ClassesType _classesType, _updatedClassesType;
  late AddNewClassesTypeTemplate _addNewClassesTypeTemplate;
  late Map _args;
  late Function? _parentUpdateFunction;

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _parentUpdateFunction = _args[AppStrings.function];
    _classesType = _args[AppStrings.classesType];
    _addNewClassesTypeTemplate =
        AddNewClassesTypeTemplate(classesType: _classesType);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              '${AppStrings.edit} ${AppStrings.classesType.toLowerCase()}',
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              _classesType.name,
              style: Theme.of(context).textTheme.headline2,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          _addNewClassesTypeTemplate,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  _updateValuesInDb();
                  SnackBarInfoTemplate(
                      context: context,
                      message:
                          '${AppStrings.updated} ${_classesType.name} ${AppStrings.successfully}!');
                  Navigator.pop(context);
                },
                child: const Text(AppStrings.ok),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateValuesInDb() {
    _updatedClassesType = _classesType;

    _updatedClassesType.name =
        _addNewClassesTypeTemplate.getClassType().name == ''
            ? _classesType.name
            : _addNewClassesTypeTemplate.getClassType().name;
    _updatedClassesType.priceForEach =
        _addNewClassesTypeTemplate.getClassType().priceForEach < 0
            ? _classesType.priceForEach
            : _addNewClassesTypeTemplate.getClassType().priceForEach;
    _updatedClassesType.priceForMonth =
        _addNewClassesTypeTemplate.getClassType().priceForMonth < 0
            ? _classesType.priceForMonth
            : _addNewClassesTypeTemplate.getClassType().priceForMonth;
    _setNewValues();
    _classesType.addToDb();
  }

  void _setNewValues() {
    setState(() {
      _setNewName();
      _setNewPriceForEach();
      _setNewPriceForMonth();
      _setNewTeacher();
    });

    if (_parentUpdateFunction != null) {
      _parentUpdateFunction!(_classesType);
    }
  }

  bool _isNamesAreDifferent() => _updatedClassesType.name != _classesType.name;

  bool _isPriceForEachAreDifferent() =>
      _updatedClassesType.priceForEach != _classesType.priceForEach;

  bool _isPriceForMonthAreDifferent() =>
      _updatedClassesType.priceForMonth != _classesType.priceForMonth;

  bool _isTeachersAreDifferent() =>
      _updatedClassesType.teacher.targetId != _classesType.teacher.targetId;

  void _setNewName() {
    if (_isNamesAreDifferent()) {
      _classesType.name = _updatedClassesType.name;
    }
  }

  void _setNewPriceForEach() {
    if (_isPriceForEachAreDifferent()) {
      _classesType.priceForEach = _updatedClassesType.priceForEach;
    }
  }

  void _setNewPriceForMonth() {
    if (_isPriceForMonthAreDifferent()) {
      _classesType.priceForMonth = _updatedClassesType.priceForMonth;
    }
  }

  void _setNewTeacher() {
    if (_isTeachersAreDifferent()) {
      _classesType.teacher.target = _updatedClassesType.teacher.target;
    }
  }
}
