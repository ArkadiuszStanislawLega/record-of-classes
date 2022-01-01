import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/person.dart';

class ParentDetailPage extends StatefulWidget {
  const ParentDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ParentDetailPage();
  }
}

class _ParentDetailPage extends State<ParentDetailPage> {
  String _parentName = '', _parentSurname = '';
  late Parent _parent;
  bool _isEdited = false;

  @override
  Widget build(BuildContext context) {
    _parent = ModalRoute.of(context)!.settings.arguments as Parent;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${_parent.person.target!.surname} ${_parent.person.target!.name}'),
      ),
      body: Column(
        children: _isEdited ? editModeEnabled() : editModeDisabled(),
      ),
    );
  }

  List<Widget> editModeEnabled() {
    return [
      TextField(
        decoration: InputDecoration(
          hintText:
          _parent.person.target!.name == '' ? Strings.NAME : _parent.person
              .target!.name,
        ),
        onChanged: (userInput) {
          _parentName = userInput;
        },
      ),
      TextField(
        decoration: InputDecoration(
          hintText: _parent.person.target!.surname == ''
              ? Strings.SURNAME
              : _parent.person.target!.surname,
        ),
        onChanged: (userInput) {
          _parentSurname = userInput;
        },
      ),
      Center(
        child: Row(children: [
          TextButton(
            onPressed: confirmEditChanges,
            child: const Text(Strings.OK),
          ),
          TextButton(
            onPressed: cancelEditChanges,
            child: const Text(Strings.CANCEL),
          )
        ]),
      ),
    ];
  }

  List<Widget> editModeDisabled(){
    List<Widget> widgets = [];
    widgets.add(Text('Dzieci:'));
    for (var child in _parent.children) {widgets.add(Text('${child.person.target!.surname} ${child.person.target!.name}'));}
    widgets.add(Text('Kontakty:'));
    for (var element in _parent.phone) {widgets.add(Text(element.toString()));}
    widgets.add(TextButton(onPressed: enableEditMode, child: const Text(Strings.EDIT)));
    return widgets;
  }

  void cancelEditChanges() {
    _parentName = '';
    _parentSurname = '';

    disableEditMode();
  }

  void confirmEditChanges() {
    setNewValues();
    updateValueInDatabase();
    disableEditMode();
  }

  void setNewValues() {
    if (_parentName != '') {
      _parent.person.target!.name = _parentName;
    }
    if (_parentSurname != '') {
      _parent.person.target!.surname = _parentSurname;
    }
  }

  void updateValueInDatabase() => objectBox.store.box<Person>().put(_parent.person.target!);

  void enableEditMode() => setState(() => _isEdited = true);
  void disableEditMode() => setState(() => _isEdited = false);

}
