import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/address.dart';
import 'package:record_of_classes/widgets/templates/text_fields/text_field_template.dart';

class CreateAddressTemplate extends StatefulWidget {
  CreateAddressTemplate({Key? key, this.address}) : super(key: key) {
    _city = TextFieldTemplate(
        label: AppStrings.city, hint: address == null ? '' : address!.city);
    _street = TextFieldTemplate(
        label: AppStrings.street, hint: address == null ? '' : address!.street);
    _houseNumber = TextFieldTemplate(
        label: AppStrings.houseNumber,
        hint: address == null ? '' : address!.houseNumber);
    _flatNumber = TextFieldTemplate(
        label: AppStrings.flatNumber,
        hint: address == null ? '' : address!.flatNumber);
  }

  Address? address;

  late TextFieldTemplate _city, _street, _houseNumber, _flatNumber;

  void clearFields() {
    _city.clear();
    _street.clear();
    _houseNumber.clear();
    _flatNumber.clear();
  }

  Address getAddress() {
    return Address(
        city: _city.userInput,
        street: _street.userInput,
        flatNumber: _flatNumber.userInput,
        houseNumber: _houseNumber.userInput);
  }

  @override
  _CreateAddressTemplateState createState() => _CreateAddressTemplateState();
}

class _CreateAddressTemplateState extends State<CreateAddressTemplate> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget._city,
        widget._street,
        widget._houseNumber,
        widget._flatNumber
      ],
    );
  }
}
