import 'package:objectbox/objectbox.dart';

import 'person.dart';

@Entity()
class Teacher {
  late int id;
  final person = ToOne<Person>();

  Teacher({this.id = 0});
}
