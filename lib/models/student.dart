import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:objectbox/objectbox.dart';

import 'person.dart';

@Entity()
class Student {
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

  String introduceYourself () => person.target!.introduceYourself();

  void removeParentFromDb(Parent parent){
    // var parentBox = objectBox.store.box<Parent>();
    // var personBox = objectBox.store.box<Person>();
    // var phoneBox = objectBox.store.box<Phone>();
    //
    // parents.removeWhere((element) => element.id == parent.id);
    // parent.children.removeWhere((element) => element.id == id);
    //
    // for (var element in parent.person.target!.phones) {
    //   phoneBox.remove(element.id);
    //   element.owner.target!.removeAllPhonesDb()
    // }
    // parent.person.target!.phones
    //     .removeWhere((element) => element.owner.targetId == parent.id);
    //
    // parentBox.remove(parent.id);
    // personBox.remove(parent.person.target!.id);
  }

  void fundAccountDb(double value){
    account.target!.balance += value;
    objectBox.store.box<Account>().put(account.target!);
  }

  void _removeAllParentRelations(){
    parents.clear();
  }

  void updateValues(Student student){
    person.target!.updateValues(student.person.target!);
    age = student.age;
    objectBox.store.box<Student>().put(this);
  }

  void removeFromDb(){
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
