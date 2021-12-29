import 'package:objectbox/objectbox.dart';

import 'account.dart';
import 'classes.dart';

@Entity()
class Bill {
  late int id;
  late bool isPaid;
  late double price;
  final classes = ToOne<Classes>();
  final student = ToOne<Account>();
}
