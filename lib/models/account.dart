import 'package:record_of_classes/models/student.dart';

import 'bill.dart';

class Account{
  late int id;
  late Student student;
  late List<Bill> notPaid;
  late List<Bill> paid;
}