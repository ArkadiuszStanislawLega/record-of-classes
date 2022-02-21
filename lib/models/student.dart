import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/db_model.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/phone.dart';

import 'person.dart';

@Entity()
class Student implements DbModel {
  late int id;
  late int age;
  final person = ToOne<Person>();
  final account = ToOne<Account>();
  final parents = ToMany<Parent>();
  final siblings = ToMany<Student>();
  final groups = ToMany<Group>();
  final attendancesList = ToMany<Attendance>();

  Student({this.id = 0, required this.age});

  @override
  String toString() {
    if (person.target != null) {
      return '$id $age ${person.target.toString()}';
    }
    return '$id $age - null person';
  }

  String introduceYourself() => person.target!.introduceYourself();

  void addParentToDb(Parent parent) {
    parents.add(parent);
    parent.children.add(this);
    addToDb();
    parent.addToDb();
  }

  void removeParentFromDb(Parent parent) {
    var parentBox = ObjectBox.store.box<Parent>();
    var personBox = ObjectBox.store.box<Person>();
    var phoneBox = ObjectBox.store.box<Phone>();

    parents.removeWhere((studentsParent) => studentsParent.id == parent.id);
    parent.children.removeWhere((children) => children.id == id);

    for (var element in parent.person.target!.phones) {
      phoneBox.remove(element.id);
    }

    parent.person.target!.phones
        .removeWhere((element) => element.owner.targetId == parent.id);
    parentBox.remove(parent.id);
    personBox.remove(parent.person.target!.id);
  }

  void fundAccountDb(double value) {
    account.target!.balance += value;
    account.target!.addToDb();
  }

  void removeSelectedParentRelation(Parent parent) {
    parent.children.removeWhere((s) => s.id == id);
    parents.removeWhere((p) => p.id == parent.id);
    parent.addToDb();
    addToDb();
  }

  void _removeAllParentRelations() {
    parents.clear();
  }

  void removeAttendance(int id) {
    attendancesList.removeWhere((attendance) => attendance.id == id);
    addToDb();
  }

  void addAttendance(Attendance attendance) {
    attendancesList.add(attendance);
    addToDb();
  }

  void updateValues(Student student) {
    person.target!.update(student.person.target!);
    age = student.age;
    addToDb();
  }

  @override
  void removeFromDb() {
    parents.clear();
    siblings.clear();
    groups.clear();

    addToDb();
    account.target?.removeFromDb();
    person.target!.removeFromDb();
    ObjectBox.store.box<Student>().remove(id);
  }

  @override
  void addToDb() => ObjectBox.store.box<Student>().put(this);

  @override
  getFromDb() => ObjectBox.store.box<Student>().get(id);

  @override
  void update(updatedObject) {
    person.target!.update(updatedObject.person.target!);
    age = updatedObject.age;
    addToDb();
  }
}
