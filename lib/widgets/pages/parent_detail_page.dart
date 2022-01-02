import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
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
  bool _isEdited = false;
  late Parent _parent;
  late Store _store;
  late Stream<List<Parent>> _parentStream;

  @override
  Widget build(BuildContext context) {
    _parent = ModalRoute.of(context)!.settings.arguments as Parent;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${_parent.person.target!.surname} ${_parent.person.target!.name}'),
      ),
      body: Column(
        children: _isEdited ? _editModeEnabled() : _editModeDisabled(),
      ),
    );
  }

  List<Widget> _editModeEnabled() {
    return [
      TextField(
        decoration: InputDecoration(
          hintText: _parent.person.target!.name == ''
              ? Strings.NAME
              : _parent.person.target!.name,
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

  List<Widget> _editModeDisabled() {
    List<Widget> widgets = [];
    _parentStream = _store
        .box<Parent>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());

    widgets.add(
      StreamBuilder<List<Parent>>(
        stream: _parentStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _store.box<Parent>().get(_parent.id);
            return Column(
              children: [
                const Text('${Strings.CHILDREN}:'),
                _childrenList(),
                const Text('${Strings.CONTACTS}:'),
                _phonesList()
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
    widgets.add(TextButton(onPressed: enableEditMode, child: const Text(Strings.EDIT)));
    return widgets;
  }

  ListView _childrenList(){
    return ListView.builder(
      itemCount: _parent.children.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _childrenListItem(index);
      },
    );
  }

  Widget _childrenListItem(int index){
    var childrenPerson = _parent.children.elementAt(index).person.target;
    return Text('${childrenPerson?.surname} ${childrenPerson?.name}');
  }

  ListView _phonesList(){
    return  ListView.builder(
      itemCount: _parent.phone.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _phoneListItem(index);
      },
    );
  }

  Widget _phoneListItem(int index){
    var phone = _parent.phone.elementAt(index);
    return Text('${phone.numberName}: ${phone.number}');
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

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
  }
}
