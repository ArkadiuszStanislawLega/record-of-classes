import 'package:objectbox/objectbox.dart';

import 'account.dart';
import 'classes.dart';

@Entity()
class Bill {
  late int id;
  late bool isPaid;
  late ToOne<Classes> classes;
  late ToOne<Account> student;
}