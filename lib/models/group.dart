import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/student.dart';

import 'classes_type.dart';

@Entity()
class Group{
  late int id;
  late String name;
  late ToOne<ClassesType> classesType;
  late ToMany<Student> students;
}

