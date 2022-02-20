import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/db_model.dart';

import 'package:record_of_classes/models/student.dart';

import 'person.dart';

@Entity()
class Parent implements DbModel {
  late int id;
  final person = ToOne<Person>();
  final children = ToMany<Student>();

  Parent({this.id = 0});

  @override
  String toString() {
    if (person.target != null) {
      '$id,  ${person.target!.surname} ${person.target!.name}';
    }
    return '$id';
  }

  String introduceYourself() {
    return person.target!.introduceYourself();
  }

  @override
  void removeFromDb() {
    // TODO: implement removeFromDb
    // var parentBox = objectBox.store.box<Parent>();
    // var personBox = objectBox.store.box<Person>();
    // var phoneBox = objectBox.store.box<Phone>();
    //
    // children.removeWhere((element) => element.id == children.id);
    // children.removeWhere((element) => element.id == id);
    //
    // person.target!.removeAllPhonesDb();
    //
    // parentBox.remove(id);
    // person.target!.removeFromDb();
  }

  @override
  void addToDb() => ObjectBox.store.box<Parent>().put(this);

  @override
  getFromDb() => ObjectBox.store.box<Parent>().get(id);

  @override
  void update(updatedObject) => addToDb();
}
