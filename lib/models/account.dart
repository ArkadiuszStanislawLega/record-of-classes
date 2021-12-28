import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/student.dart';

import 'bill.dart';

@Entity()
class Account{
  late int id;
  late ToOne<Student> student;
  late ToMany<Bill> bills;
}