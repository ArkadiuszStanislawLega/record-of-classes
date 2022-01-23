import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/attendance.dart';

import 'account.dart';

@Entity()
class Bill {
  late int id = 0;
  late bool isPaid;
  late double price;
  final studentAccount = ToOne<Account>();
  final attendance = ToOne<Attendance>();

  @override
  String toString() {
    return 'Bill{id: $id, isPaid: $isPaid, price: $price, attendance: $attendance, student: $studentAccount}';
  }

  void setIsPaidInDatabase() {
    isPaid = true;
    studentAccount.target!.balance -= price;
    _commitChanges();
  }

  void setIsUnpaidInDatabase() {
    isPaid = false;
    studentAccount.target!.balance += price;
    _commitChanges();
  }

  void _commitChanges() {
    Store store = objectBox.store;
    store.box<Bill>().put(this);
    store.box<Account>().put(studentAccount.target!);
  }

  void removeFromDb() {
    studentAccount.target = null;
    attendance.target = null;
    var box = objectBox.store.box<Bill>();
    box.put(this);
    box.remove(id);
  }
}
