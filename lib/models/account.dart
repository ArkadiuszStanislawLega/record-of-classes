import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/student.dart';

import 'bill.dart';

@Entity()
class Account {
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

  void removeFromDb() {
    for (var bill in bills) {
      bill.removeFromDb();
    }
    bills.clear();
    student.target = null;
    var box = objectBox.store.box<Account>();
    box.put(this);
    box.remove(id);
  }

  void addValueToBalance(double value) {
    balance += value;
    objectBox.store.box<Account>().put(this);
  }

  void addBill(Bill bill) {
    bills.add(bill);
    objectBox.store.box<Account>().put(this);
  }
}
