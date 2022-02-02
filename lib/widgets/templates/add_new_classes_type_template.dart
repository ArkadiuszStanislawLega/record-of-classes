import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/classes_type.dart';

class AddNewClassesTypeTemplate extends StatefulWidget {
  AddNewClassesTypeTemplate({Key? key, this.classesType}) : super(key: key);
  ClassesType? classesType;

  String _inputPriceForEach = '',
      _inputPriceForMonth = '',
      _inputClassTypeName = '';

  final TextEditingController _priceForEachController = TextEditingController(),
      _priceForMonthController = TextEditingController(),
      _nameOfClassesController = TextEditingController();

  bool _isPriceForEachIsValid() =>
      double.tryParse(_inputPriceForEach) != null ? true : false;

  bool _isPriceForMonthIsValid() =>
      double.tryParse(_inputPriceForMonth) != null ? true : false;

  bool isInputValid() => _isPriceForEachIsValid() && _isPriceForMonthIsValid();

  void clearFields() {
    _inputClassTypeName = '';
    _inputPriceForEach = '';
    _inputPriceForMonth = '';
    _nameOfClassesController.clear();
    _priceForEachController.clear();
    _priceForMonthController.clear();
  }

  ClassesType getClassType() {
    return ClassesType(
        name: _inputClassTypeName,
        priceForEach: double.parse(_inputPriceForEach),
        priceForMonth: double.parse(_inputPriceForMonth));
  }

  @override
  _AddNewClassesTypeTemplateState createState() =>
      _AddNewClassesTypeTemplateState();
}

class _AddNewClassesTypeTemplateState extends State<AddNewClassesTypeTemplate> {
  @override
  Widget build(BuildContext context) {
    _setInitialValues();
    return Column(
      children: [
        TextField(
          controller: widget._nameOfClassesController,
          decoration: InputDecoration(
              hintText: widget.classesType == null
                  ? AppStrings.NAME_OF_CLASSES_TYPE
                  : widget.classesType!.name),
          onChanged: (String str) =>
              str.isNotEmpty ? widget._inputClassTypeName = str : {},
        ),
        TextField(
          controller: widget._priceForEachController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: widget.classesType == null
                  ? AppStrings.PRICE_FOR_EACH
                  : widget.classesType!.priceForEach.toString()),
          onChanged: (String str) =>
              str.isNotEmpty ? widget._inputPriceForEach = str : {},
        ),
        TextField(
          controller: widget._priceForMonthController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              hintText: widget.classesType == null
                  ? AppStrings.PRICE_FOR_MONTH
                  : widget.classesType!.priceForMonth.toString()),
          onChanged: (String str) =>
              str.isNotEmpty ? widget._inputPriceForMonth = str : {},
        ),
      ],
    );
  }

  void _setInitialValues(){
    if (widget.classesType != null){
      widget._inputClassTypeName = widget.classesType!.name;
      widget._inputPriceForEach = widget.classesType!.priceForEach.toString();
      widget._inputPriceForMonth = widget.classesType!.priceForMonth.toString();
    }
  }
}
