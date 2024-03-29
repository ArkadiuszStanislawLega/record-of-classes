import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/db_model.dart';
import 'package:record_of_classes/models/teacher.dart';

import 'group.dart';

@Entity()
class ClassesType implements DbModel{
  late int id;
  late double priceForEach;
  late double priceForMonth;
  late String name;
  final teacher = ToOne<Teacher>();
  @Backlink()
  final groups = ToMany<Group>();

  ClassesType(
      {this.id = 0,
      this.priceForEach = 0.0,
      this.priceForMonth = 0.0,
      this.name = ''});

  @override
  String toString() {
    return 'ClassesType{id: $id, priceForEach: $priceForEach, priceForMonth: $priceForMonth, name: $name}';
  }

  void addGroup(Group group){
    group.classesType.target = this;
    groups.add(group);
    group.addToDb();
    addToDb();
  }

  void removeGroup(int id){
    for(int i = 0; i < groups.length; i++){
      groups[i].removeFromDb();
    }
    groups.clear();
  }

  int numberOfStudents() {
    int numberOfStudents = 0;
    for (var group in groups) {
      numberOfStudents += group.students.length;
    }
    return numberOfStudents;
  }

  @override
  void removeFromDb(){
    for(int i  = 0; i < groups.length; i++){
      removeGroup(groups[i].id);
    }
    ObjectBox.store.box<ClassesType>().remove(id);
  }

  @override
  void addToDb() => ObjectBox.store.box<ClassesType>().put(this);

  @override
  getFromDb() => ObjectBox.store.box<ClassesType>().get(id);

  @override
  void update(updatedObject) => addToDb();

}
