import 'package:objectbox/objectbox.dart';

import 'account.dart';
import 'classes.dart';

@Entity()
class Bill {
  late int id= 0;
  late bool isPaid;
  late double price;
  final classes = ToOne<Classes>();
  final student = ToOne<Account>();

  @override
  String toString() {
    return 'Bill{id: $id, isPaid: $isPaid, price: $price, classes: $classes, student: $student}';
  }
}
