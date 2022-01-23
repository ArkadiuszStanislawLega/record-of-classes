import 'package:flutter_test/flutter_test.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/objectbox.g.dart';

Future<void> main() async {
  final store = await openStore(directory: 'test');

  test("Add persson to db", () async {
    var personBox = store.box<Person>();

    Person person  = Person()
      ..surname = 'personSurname'
      ..name = 'parsonName';

    personBox.put(person);


    expect(personBox.getAll().length, 1);
  });
}