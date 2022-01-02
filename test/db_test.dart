import 'package:flutter_test/flutter_test.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';

void main() {

  test("Add persson to db", () async {
    ObjectBox objectBox = await ObjectBox.create();

    var person = Person(name: 'TestPerson name', surname: 'TestPerson surname');
    var student = Student(age: 12);
    var account = Account();

    student.account.target = account;
    person.student.target = student;

    objectBox.store.box<Person>().put(person);
    var persons = objectBox.store.box<Person>().getAll();

    expect(persons.length, 1);
    expect(persons.elementAt(0).id, 1);

    var personDb = objectBox.store.box<Person>().get(1);

    expect(personDb!.student.target!.account.target!.id, 1);
  });
}