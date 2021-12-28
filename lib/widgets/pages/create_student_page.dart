import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/objectbox.g.dart';

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

  late Stream<List<Person>> _personStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create student page'),
      ),
      body:           SingleChildScrollView( child: Column(
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
              // Navigator.pop(
              //   context,
              // );
            },
            child: const Text(Strings.CREATE_STUDENT),
          ),

            SizedBox(
              child: StreamBuilder<List<Person>>(
                stream: _personStream,
                builder: (context, snapshot) {
                  return DataTable(
                    columns: const [
                      DataColumn(
                        label: Text('ID'),
                      ),
                      DataColumn(
                        label: Text('Imię'),
                      ),
                      DataColumn(
                        label: Text('Nazwisko'),
                      ),
                    ],
                    rows: snapshot.data!.map(
                      (person) {
                        return DataRow(cells: [
                          DataCell(
                            Text(person.id.toString()),
                          ),
                          DataCell(
                            Text(person.name),
                          ),
                          DataCell(
                            Text(person.surname),
                          ),
                        ]);
                      },
                    ).toList(),
                  );
                },
              ),
            ),
          ],)
        ),
      );

  }

  void createNewPerson() {
    var createdPerson = Person(name: personName, surname: personSurname);
    _store.box<Person>().put(createdPerson);
    setState(() {
      // persons = _store.box<Person>().getAll();
      //persons = _store.box<Person>().query(Person_.id.greaterThan(0)..order(Person_.id, flags: Order.descending)).build();
    });
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _personStream = _store
        .box<Person>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
