import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/student.dart';

import 'bill.dart';

@Entity()
class Attendance {
  late int id = 0;
  late bool isPresent;
  final classes = ToOne<Classes>();
  final bill = ToOne<Bill>();
  final student = ToOne<Student>();

  Attendance({this.isPresent = false});

  void removeFromDb() {
    bill.target!.removeFromDb();
    classes.target!.removeClasses(id);
    student.target!.removeAttendance(id);
    objectBox.store.box<Attendance>().remove(id);
  }

  void addToDb() => objectBox.store.box<Attendance>().put(this);

  void setBill(Bill createdBill) {
    bill.target = createdBill;
    _commitChanges();
  }

  void _commitChanges() => objectBox.store.box<Attendance>().put(this);
}
