import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/student.dart';

@Entity()
class Attendance {
  late int id = 0;
  late bool isPresent;
  final classes = ToOne<Classes>();
  final student = ToOne<Student>();
}