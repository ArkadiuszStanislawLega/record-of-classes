import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/student.dart';

@Entity()
class Attendance{
  late int id;
  late bool isPresent;
  late ToOne<Classes> classes;
  late ToOne<Student> student;
}