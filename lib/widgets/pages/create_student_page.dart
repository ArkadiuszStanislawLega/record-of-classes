import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/objectbox.g.dart';
import 'package:path/path.dart';

import '../../main.dart';
import '../../main.dart';

class CreateStudentPage extends StatefulWidget {
  const CreateStudentPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateStudentPage();
  }
}

class _CreateStudentPage extends State<CreateStudentPage> {
  late Store _store;
  bool hasBeenInitialized = false;
  String personName = '', personSurname = '';
  List<Person> persons = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create student page'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.NAME,
            ),
            onChanged: (userInput) => setState(
              () {
                personName = userInput;
              },
            ),
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: Strings.SURNAME,
            ),
            onChanged: (userInput) => setState(
              () {
                personSurname = userInput;
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              var person = Person(name: personName, surname: personSurname);
              _store.box<Person>().put(person);
              Navigator.pop(
                context,
              );
            },
            child: const Text(Strings.CREATE_STUDENT),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: persons.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(persons.elementAt(index).toString()),
              );
            },
          )
        ],
      ),
    );
  }

  void createNewPerson() {
    var createdPerson = Person(name: personName, surname: personSurname);
    _store.box<Person>().put(createdPerson);
    setState(() {
      persons = _store.box<Person>().getAll();
    });
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    persons = _store.box<Person>().getAll();
  }
}
