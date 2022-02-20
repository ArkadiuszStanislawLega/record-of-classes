import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/db_model.dart';

import 'account.dart';

@Entity()
class Bill implements DbModel {
  late int id;
  late bool isPaid;
  late double price;
  final studentAccount = ToOne<Account>();
  final attendance = ToOne<Attendance>();

  Bill({this.id = 0});

  @override
  String toString() {
    return 'Bill{id: $id, isPaid: $isPaid, price: $price, attendance: $attendance, student: $studentAccount}';
  }

  void setIsPaidInDb() {
    isPaid = true;
    addToDb();
  }

  void setIsUnpaidInDb() {
    isPaid = false;
    addToDb();
  }

  @override
  void removeFromDb() {
    studentAccount.target = null;
    attendance.target = null;
    addToDb();
    ObjectBox.store.box<Bill>().remove(id);
  }

  @override
  void addToDb() => ObjectBox.store.box<Bill>().put(this);

  @override
  getFromDb() => ObjectBox.store.box<Bill>().get(id);

  @override
  void update(updatedObject) => addToDb();
}
