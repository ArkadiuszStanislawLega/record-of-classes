import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/enumerators/ActionType.dart';
import 'package:record_of_classes/enumerators/ModelType.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/db_model.dart';
import 'package:record_of_classes/models/log.dart';
import 'package:record_of_classes/models/student.dart';

import 'bill.dart';

@Entity()
class Account implements DbModel {
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
    update(this);
    ObjectBox.store.box<Account>().remove(id);

    Log log = Log(
        actionType: ActionType.remove.index,
        modelType: ModelType.account.index,
        participatingClassId: id);
    log.addToDb();
  }

  void fundBalance(double value) {
    if (value > 0) {
      Log log = Log(
          modelType: ModelType.account.index,
          actionType: ActionType.increase.index,
          participatingClassId: id,
          valueBeforeChange: balance.toString(),
          value: value.toString());

      balance += value;
      ObjectBox.store.box<Account>().put(this);
      log.addToDb();
    }
  }

  void reduceBalance(double value) {
    if (value > 0) {
      Log log = Log(
          modelType: ModelType.account.index,
          actionType: ActionType.decrease.index,
          participatingClassId: id,
          valueBeforeChange: balance.toString(),
          value: '-${value.toString()}');

      balance -= value;
      ObjectBox.store.box<Account>().put(this);
      log.addToDb();
    }
  }

  void addBill(Bill bill) {
    bills.add(bill);
    update(this);
  }

  @override
  void addToDb() {
    ObjectBox.store.box<Account>().put(this);

    Log log = Log(
        modelType: ModelType.account.index,
        actionType: ActionType.add.index,
        participatingClassId: id);
    log.addToDb();
  }

  @override
  getFromDb() => ObjectBox.store.box<Account>().get(id);

  @override
  void update(updateObject) {
    balance = updateObject.balance;
    ObjectBox.store.box<Account>().put(this);

    Log log = Log(
        modelType: ModelType.account.index,
        actionType: ActionType.update.index,
        participatingClassId: id);

    log.addToDb();
  }
}
