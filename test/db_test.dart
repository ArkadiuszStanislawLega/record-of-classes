import 'package:flutter_test/flutter_test.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/person.dart';

void main() {

  test("Add persson to db", () async {
    ObjectBox objectBox = await ObjectBox.create();
    final personsBox = objectBox.store.box<Person>();
    personsBox.put(Person(name:'test', surname: 'Surname test'));

    expect(personsBox.getAll().length, 1);
  });
}