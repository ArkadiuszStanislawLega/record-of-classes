import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/db_model.dart';
import 'package:record_of_classes/models/student.dart';

import 'bill.dart';

@Entity()
class Account implements DbModel{
  late int id;
  late double balance;
  final student = ToOne<Student>();
  @Backlink()
  final bills = ToMany<Bill>();

  @override
  String toString() {
    return 'Account{id: $id, balance: $balance, student: ${student.target!.introduceYourself()}, bills: ${bills.length}}';
  }

  Account({this.id = 0, this.balance = 0.0});

  double countUnpaidBillsPrice() {
    double unpaid = 0.0;
    for (var element in bills) {
      if (!element.isPaid) {
        unpaid += element.price;
      }
    }
    return unpaid;
  }

  int countUnpaidBills() {
    int unpaid = 0;
    for (var element in bills) {
      if (!element.isPaid) {
        unpaid++;
      }
    }
    return unpaid;
  }

  double countPaidBills() {
    double unpaid = 0.0;
    for (var element in bills) {
      if (element.isPaid) {
        unpaid += element.price;
      }
    }
    return unpaid;
  }

  @override
  void removeFromDb() {
    for (var bill in bills) {
      bill.removeFromDb();
    }
    bills.clear();
    student.target = null;
    addToDb();
    ObjectBox.store.box<Account>().remove(id);
  }

  void addValueToBalance(double value) {
    balance += value;
    addToDb();
  }

  void addBill(Bill bill) {
    bills.add(bill);
    addToDb();
  }

  @override
  void addToDb() => ObjectBox.store.box<Account>().put(this);

  @override
  getFromDb() => ObjectBox.store.box<Account>().get(id);

  @override
  void update(updateObject) => addToDb();
}
