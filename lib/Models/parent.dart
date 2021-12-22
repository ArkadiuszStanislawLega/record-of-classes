import 'package:record_of_classes/Models/phone.dart';
import 'package:record_of_classes/Models/student.dart';

import 'person.dart';

class Parent extends Person{
  late int parentId;
  late Phone phone;
  late List<Student> childrenId;
}