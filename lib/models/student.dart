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
class Student extends DbModel {
  late int id;
  late int age;
  final person = ToOne<Person>();
  final account = ToOne<Account>();
  final parents = ToMany<Parent>();
  final siblings = ToMany<Student>();
  final groups = ToMany<Group>();
  final attendancesList = ToMany<Attendance>();

  Student({this.id = 0, required this.age}) {
    object = this;
    super.setId = id;
  }



  @override
  String toString() {
    if (person.target != null) {
      return '$id $age ${person.target.toString()}';
    }
    return '$id $age - null person';
  }

  @override
  Student? getFromDb() => objectBox.store.box<Student>().get(id);

  @override
  void addToDb() => objectBox.store.box<Student>().put(this);

  String introduceYourself() => person.target!.introduceYourself();

  void addParentToDb(Parent parent) {
    parents.add(parent);
    parent.children.add(this);
    objectBox.store.box<Student>().put(this);
    objectBox.store.box<Parent>().put(parent);
  }

  void removeParentFromDb(Parent parent) {
    var parentBox = objectBox.store.box<Parent>();
    var personBox = objectBox.store.box<Person>();
    var phoneBox = objectBox.store.box<Phone>();

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
    objectBox.store.box<Account>().put(account.target!);
  }

  void removeSelectedParentRelation(Parent parent) {
    parent.children.removeWhere((s) => s.id == id);
    parents.removeWhere((p) => p.id == parent.id);
    objectBox.store.box<Parent>().put(parent);
    objectBox.store.box<Student>().put(this);
  }

  void _removeAllParentRelations() {
    parents.clear();
  }


  void removeAttendance(int id) {
    attendancesList.removeWhere((attendance) => attendance.id == id);
    objectBox.store.box<Student>().put(this);
  }

  void addAttendance(Attendance attendance) {
    attendancesList.add(attendance);
    objectBox.store.box<Student>().put(this);
  }

  void updateValues(Student student) {
    person.target!.update(student.person.target!);
    age = student.age;
    objectBox.store.box<Student>().put(this);
  }

  @override
  void removeFromDb() {
    account.target?.removeFromDb();
    parents.clear();
    siblings.clear();
    groups.clear();

    var box = objectBox.store.box<Student>();
    box.put(this);
    box.remove(id);
    person.target!.removeFromDb();
  }
}
