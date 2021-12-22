import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/models/student.dart';

import 'person.dart';

class Parent extends Person{
  late int parentId;
  late Phone phone;
  late List<Student> childrenId;
}