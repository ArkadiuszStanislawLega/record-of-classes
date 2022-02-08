import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/db_model.dart';
import 'package:record_of_classes/models/student.dart';

import 'address.dart';
import 'classes_type.dart';

@Entity()
class Group implements DbModel{
  late int id;
  late String name;
  final address = ToOne<Address>();
  final classesType = ToOne<ClassesType>();
  final students = ToMany<Student>();
  final classes = ToMany<Classes>();

  @override
  String toString() {
    return 'Group{id: $id, name: $name, address: ${address.target}, classesType: ${classesType.target!.name}, students: ${students.length}, classes: ${classes.length}}';
  }

  Group({this.id = 0, this.name = ''});
  
  void removeClasses(int id) {
    var selectedClasses = classes.firstWhere((element) => element.id == id);
    selectedClasses.removeFromDb();
    classes.removeWhere((classes) => classes.id == id);
  }

  void addClasses(Classes classesToAdd) {
    classesToAdd.group.target = this;
    classes.add(classesToAdd);
    classesToAdd.addToDb();
    addToDb();
  }

  @override
  void removeFromDb() {
    address.target!.groups.removeWhere((group) => group.id == id);
    classesType.target!.groups.removeWhere((group) => group.id == id);
    for (var student in students) {
      student.groups.removeWhere((element) => element.id == id);
    }
    for (var element in classes) {
      element.removeFromDb();
    }
    removeFromDb();
  }

  @override
  void addToDb() => objectBox.store.box<Group>().put(this);

  @override
  getFromDb() => objectBox.store.box<Group>().get(id);

  @override
  void update(updatedObject)=> addToDb();

}
