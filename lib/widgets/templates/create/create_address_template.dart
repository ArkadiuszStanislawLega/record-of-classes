import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/address.dart';

class CreateAddressTemplate extends StatefulWidget {
  CreateAddressTemplate({Key? key, this.address}) : super(key: key);
  Address? address;

  String _inputStreet = '',
      _inputHouseNumber = '',
      _inputFlatNumber = '',
      _inputCity = '';

  final TextEditingController _streetController = TextEditingController(),
      _houseNumberController = TextEditingController(),
      _flatNumberController = TextEditingController(),
      _cityController = TextEditingController();

  void clearFields() {
    _inputFlatNumber = '';
    _inputStreet = '';
    _inputHouseNumber = '';
    _inputCity = '';
    _flatNumberController.clear();
    _streetController.clear();
    _houseNumberController.clear();
    _cityController.clear();
  }

  Address getAddress() {
    return Address(
        city: _inputCity,
        street: _inputStreet,
        flatNumber: _inputFlatNumber,
        houseNumber: _inputHouseNumber);
  }

  @override
  _CreateAddressTemplateState createState() => _CreateAddressTemplateState();
}

class _CreateAddressTemplateState extends State<CreateAddressTemplate> {
  @override
  Widget build(BuildContext context) {
    _setInitialValues();
    return Column(
      children: [
        TextField(
          controller: widget._cityController,
          decoration: InputDecoration(
              hintText: widget.address == null
                  ? Strings.CITY
                  : widget.address!.city),
          onChanged: (String str) =>
          str.isNotEmpty ? widget._inputCity = str : {},
        ),
        TextField(
          controller: widget._streetController,
          decoration: InputDecoration(
              hintText: widget.address == null
                  ? Strings.STREET
                  : widget.address!.street),
          onChanged: (String str) =>
              str.isNotEmpty ? widget._inputStreet = str : {},
        ),
        TextField(
          controller: widget._houseNumberController,
          decoration: InputDecoration(
              hintText: widget.address == null
                  ? Strings.HOUSE_NUMBER
                  : widget.address!.houseNumber),
          onChanged: (String str) =>
              str.isNotEmpty ? widget._inputHouseNumber = str : {},
        ),
        TextField(
          controller: widget._flatNumberController,
          decoration: InputDecoration(
              hintText: widget.address == null
                  ? Strings.FLAT_NUMBER
                  : widget.address!.flatNumber),
          onChanged: (String str) =>
              str.isNotEmpty ? widget._inputFlatNumber = str : {},
        ),

      ],
    );
  }

  void _setInitialValues() {
    if (widget.address != null) {
      widget._inputCity = widget.address!.city;
      widget._inputStreet = widget.address!.street;
      widget._inputHouseNumber = widget.address!.houseNumber;
      widget._inputFlatNumber = widget.address!.flatNumber;
    }
  }
}
