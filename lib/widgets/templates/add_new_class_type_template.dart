import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/classes_type.dart';

class AddNewClassTypeTemplate extends StatefulWidget {
  AddNewClassTypeTemplate({Key? key}) : super(key: key);

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

  void clearFields(){
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
  _AddNewClassTypeTemplateState createState() =>
      _AddNewClassTypeTemplateState();
}

class _AddNewClassTypeTemplateState extends State<AddNewClassTypeTemplate> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget._nameOfClassesController,
          decoration: const InputDecoration(hintText: Strings.NAME_OF_CLASSES_TYPE),
          onChanged: (String str) =>
              str.isNotEmpty ? widget._inputClassTypeName = str : {},
        ),
        TextField(
          controller: widget._priceForEachController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: Strings.PRICE_FOR_EACH),
          onChanged: (String str) =>
              str.isNotEmpty ? widget._inputPriceForEach = str : {},
        ),
        TextField(
          controller: widget._priceForMonthController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: Strings.PRICE_FOR_MONTH),
          onChanged: (String str) =>
              str.isNotEmpty ? widget._inputPriceForMonth = str : {},
        ),
      ],
    );
  }
}
