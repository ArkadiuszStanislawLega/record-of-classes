import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/student.dart';

import 'bill.dart';

@Entity()
class Account {
  late int id;
  final student = ToOne<Student>();
  @Backlink()
  final bills = ToMany<Bill>();

  Account({this.id = 0});
}
