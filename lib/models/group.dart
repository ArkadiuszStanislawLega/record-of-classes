import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/models/student.dart';

import 'address.dart';
import 'classes_type.dart';

@Entity()
class Group {
  late int id;
  late String name;
  final address = ToOne<Address>();
  final classesType = ToOne<ClassesType>();
  final students = ToMany<Student>();
  final classes = ToMany<Classes>();

  Group({this.id = 0, this.name = ''});

  void addClasses(Classes classesToAdd) {
    classesToAdd.group.target = this;
    classes.add(classesToAdd);
    classesToAdd.addToDb();
    objectBox.store.box<Group>().put(this);
  }

  void removeFromDb() {
    address.target!.groups.removeWhere((group) => group.id == id);
    classesType.target!.groups.removeWhere((group) => group.id == id);
    for (var student in students) {
      student.groups.removeWhere((element) => element.id == id);
    }
    for (var element in classes) {
      element.removeFromDb();
    }
    objectBox.store.box<Group>().remove(id);
  }
}
