import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/teacher.dart';

import 'group.dart';

@Entity()
class ClassesType {
  late int id;
  late double priceForEach;
  late double priceForMonth;
  late String name;
  final teacher = ToOne<Teacher>();
  @Backlink()
  final groups = ToMany<Group>();

  ClassesType(
      {this.id = 0,
      this.priceForEach = 0.0,
      this.priceForMonth = 0.0,
      this.name = ''});

  @override
  String toString() {
    return 'ClassesType{id: $id, priceForEach: $priceForEach, priceForMonth: $priceForMonth, name: $name}';
  }

  int numberOfStudents() {
    int numberOfStudents = 0;
    for (var group in groups) {
      numberOfStudents += group.students.length;
    }
    return numberOfStudents;
  }
}
