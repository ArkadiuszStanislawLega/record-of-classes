import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class EditParentPage extends StatefulWidget {
  const EditParentPage({Key? key}) : super(key: key);

  @override
  _EditParentPageState createState() => _EditParentPageState();
}

class _EditParentPageState extends State<EditParentPage> {
  late Parent _parent;
  String _parentName = '', _parentSurname = '';

  @override
  Widget build(BuildContext context) {
    _parent = ModalRoute.of(context)!.settings.arguments as Parent;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addContact),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: _parent.person.target!.name == '' ? AppStrings.name : _parent.person.target!.name,
            ),
            onChanged: (userInput) {
              _parentName = userInput;
            },
          ),
          TextField(
            decoration: InputDecoration(
              hintText:
              _parent.person.target!.surname == '' ? AppStrings.surname : _parent.person.target!.surname,
            ),
            onChanged: (userInput) {
              _parentSurname = userInput;
            },
          ),
          TextButton(
            onPressed: _confirmEditChanges,
            child: const Text(AppStrings.ok),
          ),
        ],
      ),
    );
  }


  void _confirmEditChanges() {
    _setNewValues();
    _updateValueInDatabase();
    SnackBarInfoTemplate(context: context, message: '${AppStrings.dataHasBeenUpdated} ${_parent.introduceYourself()}');
    Navigator.pop(context);
  }

  void _setNewValues() {
    setState(() {
      if (_parentName != '') {
        _parent.person.target!.name = _parentName;
      }
      if (_parentSurname != '') {
        _parent.person.target!.surname = _parentSurname;
      }
    });
  }

  void _updateValueInDatabase() => _parent.person.target!.addToDb();
}
