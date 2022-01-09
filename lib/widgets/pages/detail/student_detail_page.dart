import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/lists/accounts_list_template.dart';
import 'package:record_of_classes/widgets/templates/lists/parents_of_student_list_template.dart';
import 'package:record_of_classes/widgets/templates/lists/siblings_list_template.dart';
import 'package:record_of_classes/widgets/templates/lists/student_groups_list_template.dart';

class StudentDetailPage extends StatefulWidget {
  const StudentDetailPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentDetailPage();
  }
}

class _StudentDetailPage extends State<StudentDetailPage> {
  late Student _student;
  late Person _person;
  late bool _isEdited = false;
  late Store _store;
  late Stream<List<Student>> _parentsStream;
  String _personAge = '', _personName = '', _personSurname = '';

  @override
  Widget build(BuildContext context) {
    _student = ModalRoute.of(context)!.settings.arguments as Student;
    _person = _student.person.target as Person;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_person.name}  ${_person.surname}'),
      ),
      body: StreamBuilder<List<Student>>(
        stream: _parentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: _isEdited ? editModeEnabled() : editModeDisabled(),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _parentsStream = _store
        .box<Student>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  List<Widget> editModeDisabled() {
    return [
      TextButton(
        onPressed: enableEditMode,
        child: const Text(Strings.EDIT),
      ),
      Text('${Strings.AGE}: ${_student.age.toString()}'),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('${Strings.PARENTS}:'),
          TextButton(
            onPressed: addParent,
            child: const Text(Strings.ADD_PARENT),
          ),
        ],
      ),
      ParentsOfStudentList(
        children: _student,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('${Strings.SIBLINGS}:'),
          TextButton(
              onPressed: addSibling, child: const Text(Strings.ADD_SIBLING))
        ],
      ),
      SiblingsListTemplate(student: _student),
      AccountListTemplate(account: _student.account),
      const Text('${Strings.GROUPS}:'),
      StudentGroupListTemplate(student: _student),
    ];
  }

  List<Widget> editModeEnabled() {
    return [
      TextField(
        decoration: InputDecoration(
          hintText: _person.name == '' ? Strings.NAME : _person.name,
        ),
        onChanged: (userInput) {
          _personName = userInput;
        },
      ),
      TextField(
        decoration: InputDecoration(
          hintText: _person.surname == '' ? Strings.SURNAME : _person.surname,
        ),
        onChanged: (userInput) {
          _personSurname = userInput;
        },
      ),
      TextField(
          onChanged: (userInput) {
            _personAge = userInput;
          },
          decoration: InputDecoration(
            hintText: _student.age == 0 ? Strings.AGE : _student.age.toString(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ]),
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

  void addParent() {
    Navigator.pushNamed(context, AppUrls.CREATE_PARENT, arguments: _student);
  }

  void addSibling() {
    Navigator.pushNamed(context, AppUrls.ADD_SIBLING, arguments: _student);
  }

  void cancelEditChanges() {
    _personAge = '';
    _personName = '';
    _personSurname = '';

    disableEditMode();
  }

  void confirmEditChanges() {
    setNewValues();
    updateValueInDatabase();
    disableEditMode();
  }

  void setNewValues() {
    if (_personName != '') {
      _student.person.target!.name = _personName;
    }
    if (_personSurname != '') {
      _student.person.target!.surname = _personSurname;
    }
    if (_personAge != '') {
      _student.age = int.parse(_personAge);
    }
  }

  void updateValueInDatabase() => objectBox.store.box<Person>().put(_person);

  void enableEditMode() => setState(() => _isEdited = true);

  void disableEditMode() => setState(() => _isEdited = false);
}
