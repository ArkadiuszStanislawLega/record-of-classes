import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/widgets/templates/text_field_template.dart';
import 'package:record_of_classes/widgets/templates/text_field_template_double.dart';

class AddNewClassesTypeTemplate extends StatefulWidget {
  AddNewClassesTypeTemplate({Key? key, this.classesType}) : super(key: key);
  ClassesType? classesType;

  late TextFieldTemplate _classesTypeName;
  late TextFieldTemplateDouble _priceForEach, _priceForMonth;

  bool _isPriceForEachIsValid() =>
      double.tryParse(_priceForEach.input) != null ? true : false;

  bool _isPriceForMonthIsValid() =>
      double.tryParse(_priceForMonth.input) != null ? true : false;

  bool isInputValid() => _isPriceForEachIsValid() && _isPriceForMonthIsValid();

  void clearFields() {
    _classesTypeName.clear();
    _priceForEach.clear();
    _priceForMonth.clear();
  }

  ClassesType getClassType() {
    return ClassesType(
        name: _classesTypeName.input,
        priceForEach: _priceForEach.input == ''
            ? -1.0
            : double.parse(_priceForEach.input.replaceAll(',', '.')),
        priceForMonth: _priceForEach.input == ''
            ? -1.0
            : double.parse(_priceForMonth.input.replaceAll(',', '.')));
  }

  @override
  _AddNewClassesTypeTemplateState createState() =>
      _AddNewClassesTypeTemplateState();
}

class _AddNewClassesTypeTemplateState extends State<AddNewClassesTypeTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          widget._classesTypeName = TextFieldTemplate(
              label: AppStrings.nameOfClassesType,
              hint: widget.classesType == null ? '' : widget.classesType!.name),
          widget._priceForEach = TextFieldTemplateDouble(
            label: AppStrings.priceForEach,
            hint: widget.classesType == null
                ? ''
                : widget.classesType!.priceForEach.toString(),
          ),
          widget._priceForMonth = TextFieldTemplateDouble(
            label: AppStrings.priceForMonth,
            hint: widget.classesType == null
                ? ''
                : widget.classesType!.priceForMonth.toString(),
          ),
        ],
      ),
    );
  }
}
