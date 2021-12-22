import 'package:record_of_classes/models/teacher.dart';

import 'group.dart';

class ClassesType {
  late int id;
  late double priceForEach;
  late double priceForMonth;
  late String name;
  late Teacher teacher;
  late List<Group> groups;

  ClassesType(
      {this.id = 0,
      this.priceForEach = 0.0,
      this.priceForMonth = 0.0,
      this.name = '',
      required this.teacher,
      this.groups = const []});
}
