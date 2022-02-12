import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
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
  late Store _store;
  late Map _args;
  late Function? _parentUpdateFunction;

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Map;
    _parentUpdateFunction = _args[AppStrings.FUNCTION];
    _classesType = _args[AppStrings.CLASSES_TYPE];
    _addNewClassesTypeTemplate =
        AddNewClassesTypeTemplate(classesType: _classesType);
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.EDIT} ${_classesType.name}'),
      ),
      body: Column(
        children: [
          _addNewClassesTypeTemplate,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  if (_isValuesAreValid()) {
                    _updateValuesInDb();
                    SnackBarInfoTemplate(
                        context: context,
                        message:
                            '${AppStrings.UPDATED} ${_classesType.name} ${AppStrings.SUCCESFULLY}!');
                    Navigator.pop(context);
                  } else {
                    SnackBarInfoTemplate(
                        context: context,
                        message: AppStrings.ERROR_MESSAGE_CHECK_FIELDS_FILL);
                  }
                },
                child: const Text(AppStrings.OK),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isValuesAreValid() => _addNewClassesTypeTemplate.isInputValid();

  void _updateValuesInDb() {
    _store = objectBox.store;
    _updatedClassesType = _addNewClassesTypeTemplate.getClassType();
    _setNewValues();
    _store.box<ClassesType>().put(_classesType);
  }

  void _setNewValues() {
    setState(() {
      _setNewName();
      _setNewPriceForEach();
      _setNewPriceForMonth();
      _setNewTeacher();
    });

    if(_parentUpdateFunction != null) {
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
