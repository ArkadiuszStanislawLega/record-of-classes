import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/student.dart';

import 'address.dart';
import 'classes_type.dart';

@Entity()
class Group {
  late int id;
  late String name;
  final address = ToOne<Address>();
  final classesType = ToOne<ClassesType>();
  final students = ToMany<Student>();
}
