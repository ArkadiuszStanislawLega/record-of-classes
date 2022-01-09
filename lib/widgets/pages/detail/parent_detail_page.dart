import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/widgets/templates/create/create_phone_template.dart';

class ParentDetailPage extends StatefulWidget {
  const ParentDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ParentDetailPage();
  }
}

class _ParentDetailPage extends State<ParentDetailPage> {
  String _parentName = '', _parentSurname = '';
  bool _isEdited = false, _isAddContactVisible = false;
  final CreatePhoneTemplate _createPhoneTemplate = CreatePhoneTemplate();
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

  Widget contactsButtons() {
    return Row(
      children: !_isAddContactVisible
          ? [
              TextButton(
                onPressed: enableAddContactMode,
                child: const Text(Strings.ADD_CONTACT),
              )
            ]
          : [
              TextButton(
                  onPressed: disableAddContactMode,
                  child: const Text(Strings.CANCEL_ADDING_CONTACTS)),
              TextButton(
                onPressed: () {
                  var phone = _createPhoneTemplate.getPhone();
                  _parent.phone.add(phone);
                  _store.box<Parent>().put(_parent);

                  disableAddContactMode();
                },
                child: const Text(Strings.ADD_CONTACT),
              )
            ],
    );
  }

  List<Widget> _editModeDisabled() {
    List<Widget> widgets = [];
    _parentStream = _store
        .box<Parent>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());

    widgets.add(
      Row(
        children: [
          TextButton(
            onPressed: enableEditMode,
            child: const Text(Strings.EDIT),
          )
        ],
      ),
    );
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
    widgets.add(contactsButtons());
    if (_isAddContactVisible) {
      widgets.add(_createPhoneTemplate);
    }

    return widgets;
  }

  ListView _childrenList() {
    return ListView.builder(
      itemCount: _parent.children.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _childrenListItem(index);
      },
    );
  }

  Widget _childrenListItem(int index) {
    var childrenPerson = _parent.children.elementAt(index).person.target;
    return Text('${childrenPerson?.surname} ${childrenPerson?.name}');
  }

  ListView _phonesList() {
    return ListView.builder(
      itemCount: _parent.phone.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _phoneListItem(index);
      },
    );
  }

  Widget _phoneListItem(int index) {
    Phone phone = _parent.phone.elementAt(index);
    return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
              caption: Strings.DELETE,
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                setState(() {
                  _parent.phone.remove(phone);
                  _store.box<Phone>().remove(phone.id);
                });
              }),
        ],
        child: ListTile(
          title: Text(phone.number.toString()),
          subtitle: Text(phone.numberName),
        ));
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

  void updateValueInDatabase() =>
      objectBox.store.box<Person>().put(_parent.person.target!);

  void enableEditMode() => setState(() => _isEdited = true);

  void disableEditMode() => setState(() => _isEdited = false);

  void enableAddContactMode() => setState(() => _isAddContactVisible = true);

  void disableAddContactMode() => setState(() => _isAddContactVisible = false);

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
  }
}
