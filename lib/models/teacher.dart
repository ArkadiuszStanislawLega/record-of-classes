import 'package:objectbox/objectbox.dart';

import 'person.dart';

@Entity()
class Teacher {
  late int id;
  late ToOne<Person> person;

  Teacher({required this.person, this.id = 0});
}
