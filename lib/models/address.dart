import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/db_model.dart';

import 'group.dart';

@Entity()
class Address extends DbModel {
  late int id;
  late String street;
  late String houseNumber;
  late String flatNumber;
  late String city;
  @Backlink()
  final groups = ToMany<Group>();


  @override
  String toString() {
    return '$city, $street $houseNumber${flatNumber == '' ? '' : '/$flatNumber'}';
  }

  Address({this.id = 0, this.street = '', this.houseNumber ='', this.flatNumber ='', this.city = ''});
}
