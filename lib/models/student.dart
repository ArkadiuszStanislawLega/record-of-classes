import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/parent.dart';

import 'person.dart';

class Student extends Person{
  late int studentId;
  late int age;
  late Account account;
  late List<Parent> parents;
  late List<Student> siblings;
  late List<Group> groups;
  late List<Attendance> attendancesList;
}