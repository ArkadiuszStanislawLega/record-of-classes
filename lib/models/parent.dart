import 'package:objectbox/objectbox.dart';

import 'package:record_of_classes/models/student.dart';

import 'person.dart';


@Entity()
class Parent{
  late int id = 0;
  final person = ToOne<Person>();
  final children = ToMany<Student>();

  @override
  String toString() {
    if (person.target != null){
      '$id,  ${person.target!.surname} ${person.target!.name}';
    }
    return '$id';
  }

  String introduceYourself(){
    return person.target!.introduceYourself();
  }

  void removeFromDb(){
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
}