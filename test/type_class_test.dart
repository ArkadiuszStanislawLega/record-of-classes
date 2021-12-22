import 'package:flutter_test/flutter_test.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/teacher.dart';

void main() {

  test("Create class", () {
    Person person = Person(id: 1, name: 'Osoba', surname: 'Onazwisku');
    Teacher teacher = Teacher(person: person, teacherId: 1);
    ClassesType classesType = ClassesType(id: 1, priceForEach: 20.40,
      priceForMonth: 80.80, name: 'Super zajecia', teacher:  teacher  );

    var expectation = classesType.teacher.teacherId;
    var value = 1;
    expect(expectation, value);
  });
}