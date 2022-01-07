import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/widgets/templates/add_new_classes_type_template.dart';

class DetailClassesType extends StatefulWidget {
  DetailClassesType({Key? key}) : super(key: key);
  late ClassesType _classesType;

  @override
  _DetailClassesTypeState createState() => _DetailClassesTypeState();
}

class _DetailClassesTypeState extends State<DetailClassesType> {
  bool _isEditModeEnabled = false;
  late Store _store;
  late AddNewClassesTypeTemplate _addNewClassesTypeTemplate;
  late ClassesType _updatedClassesType;

  @override
  Widget build(BuildContext context) {
    widget._classesType =
        ModalRoute.of(context)!.settings.arguments as ClassesType;
    _addNewClassesTypeTemplate = AddNewClassesTypeTemplate(
      classesType: widget._classesType,
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._classesType.name),
        ),
        body: _isEditModeEnabled ? _editModeEnabled() : _editModeDisabled());
  }

  Widget _editModeEnabled() {
    return Center(
      child: Column(children: [
        _addNewClassesTypeTemplate,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                if (_isValuesAreValid()) {
                  _updateValuesInDb();
                }
                _disableEditMode();
              },
              child: const Text(Strings.OK),
            ),
            TextButton(
              onPressed: () {
                _addNewClassesTypeTemplate.clearFields();
                _disableEditMode();
              },
              child: const Text(Strings.CANCEL),
            ),
          ],
        ),
      ]),
    );
  }

  bool _isValuesAreValid() => _addNewClassesTypeTemplate.isInputValid();

  void _updateValuesInDb() {
    _updatedClassesType = _addNewClassesTypeTemplate.getClassType();
    _setNewValues();
    _store.box<ClassesType>().put(widget._classesType);

    print(widget._classesType.toString());
  }

  void _setNewValues() {
    _setNewName();
    _setNewPriceForEach();
    _setNewPriceForMonth();
    _setNewTeacher();
  }

  bool _isNamesAreDifferent() =>
      _updatedClassesType.name != widget._classesType.name;

  bool _isPriceForEachAreDifferent() =>
      _updatedClassesType.priceForEach != widget._classesType.priceForEach;

  bool _isPriceForMonthAreDifferent() =>
      _updatedClassesType.priceForMonth != widget._classesType.priceForMonth;

  bool _isTeachersAreDifferent() =>
      _updatedClassesType.teacher.targetId !=
      widget._classesType.teacher.targetId;

  void _setNewName() {
    if (_isNamesAreDifferent()) {
      widget._classesType.name = _updatedClassesType.name;
    }
  }

  void _setNewPriceForEach() {
    if (_isPriceForEachAreDifferent()) {
      widget._classesType.priceForEach = _updatedClassesType.priceForEach;
    }
  }

  void _setNewPriceForMonth() {
    if (_isPriceForMonthAreDifferent()) {
      widget._classesType.priceForMonth = _updatedClassesType.priceForMonth;
    }
  }

  void _setNewTeacher() {
    if (_isTeachersAreDifferent()) {
      widget._classesType.teacher.target = _updatedClassesType.teacher.target;
    }
  }


  void _disableEditMode() => setState(() => _isEditModeEnabled = false);

  void _enableEditMode() => setState(() => _isEditModeEnabled = true);

  Widget _editModeDisabled() {
    return Column(
      children: [
        TextButton(
            onPressed: () {
              _enableEditMode();
            },
            child: const Text(Strings.EDIT)),
        Text(
            '${Strings.PRICE_FOR_MONTH}: ${widget._classesType.priceForMonth.toString()}${Strings.CURRENCY}'),
        Text(
            '${Strings.PRICE_FOR_EACH}: ${widget._classesType.priceForEach}${Strings.CURRENCY}'),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
  }
}
