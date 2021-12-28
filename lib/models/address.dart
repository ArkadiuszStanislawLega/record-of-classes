import 'package:objectbox/objectbox.dart';

import 'group.dart';

@Entity()
class Address{
  late int id;
  late String street;
  late String houseNumber;
  late String flatNumber;
  late String city;
  late ToMany<Group> groups;
}