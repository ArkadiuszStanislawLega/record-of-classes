import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/models/student.dart';

import 'person.dart';

@Entity()
class Parent{
  late int id;
  final person = ToOne<Person>();
  final phone = ToMany<Phone>();
  final children = ToMany<Student>();
}