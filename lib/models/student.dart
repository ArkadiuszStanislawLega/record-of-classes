import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:objectbox/objectbox.dart';

import 'person.dart';

@Entity()
class Student {
  late int id;
  late int age;
  final person = ToOne<Person>();
  final account = ToOne<Account>();
  final parents = ToMany<Parent>();
  final siblings = ToMany<Student>();
  final groups = ToMany<Group>();
  final attendancesList = ToMany<Attendance>();

  Student({this.id = 0, required this.age});

  @override
  String toString() {

    return '$id $age ${person.target!.toString()}';
  }
}
