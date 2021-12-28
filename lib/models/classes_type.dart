import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/teacher.dart';

import 'group.dart';

@Entity()
class ClassesType {
  late int id;
  late double priceForEach;
  late double priceForMonth;
  late String name;
  late ToOne<Teacher> teacher;
  late ToMany<Group> groups;

  ClassesType(
      {this.id = 0,
      this.priceForEach = 0.0,
      this.priceForMonth = 0.0,
      this.name = '',
      required this.teacher});
}
