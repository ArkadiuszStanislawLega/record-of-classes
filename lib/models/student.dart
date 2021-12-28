import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:objectbox/objectbox.dart';

import 'person.dart';

@Entity()
class Student{
  late int id;
  late int age;
  late ToOne<Person> person;
  late ToOne<Account> account;
  late ToMany<Parent> parents;
  late ToMany<Student> siblings;
  late ToMany<Group> groups;
  late ToMany<Attendance> attendancesList;
}