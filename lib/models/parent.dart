import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/models/student.dart';

import 'person.dart';

//    _parentsStream = _store.box<Parent>().getAll().contains(widget.children!.id) as Stream<List<Parent>>;
@Entity()
class Parent{
  late int id = 0;
  final person = ToOne<Person>();
  final phone = ToMany<Phone>();
  final children = ToMany<Student>();

  @override
  String toString() {
    if (person.target != null){
      '$id,  ${person.target!.surname} ${person.target!.name}';
    }
    return '$id';
  }
}