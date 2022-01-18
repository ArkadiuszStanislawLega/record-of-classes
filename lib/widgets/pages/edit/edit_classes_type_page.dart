import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/widgets/templates/add_new_classes_type_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class EditClassesTypePage extends StatefulWidget {
  EditClassesTypePage({Key? key}) : super(key: key);

  @override
  _EditClassesTypePageState createState() => _EditClassesTypePageState();
}

class _EditClassesTypePageState extends State<EditClassesTypePage> {
  late ClassesType _classesType, _updatedClassesType;
  late AddNewClassesTypeTemplate _addNewClassesTypeTemplate;
  late Store _store;

  @override
  Widget build(BuildContext context) {
    _classesType = ModalRoute.of(context)!.settings.arguments as ClassesType;
    _addNewClassesTypeTemplate =
        AddNewClassesTypeTemplate(classesType: _classesType);
    return Scaffold(
      appBar: AppBar(
        title: Text('${Strings.EDIT} ${_classesType.name}'),
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
                        '${Strings.UPDATED} ${_classesType.name} ${Strings.SUCCESFULLY}!');
                    Navigator.pop(context);
                  }
                  else{
                    SnackBarInfoTemplate(
                        context: context,
                        message: Strings.ERROR_MESSAGE_CHECK_FIELDS_FILL);
                  }
                },
                child: const Text(Strings.OK),
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
