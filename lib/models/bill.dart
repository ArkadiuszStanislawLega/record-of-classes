import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/attendance.dart';

import 'account.dart';

@Entity()
class Bill {
  late int id= 0;
  late bool isPaid;
  late double price;
  final studentAccount = ToOne<Account>();
  final attendance = ToOne<Attendance>();

  @override
  String toString() {
    return 'Bill{id: $id, isPaid: $isPaid, price: $price, attendance: $attendance, student: $studentAccount}';
  }
}
