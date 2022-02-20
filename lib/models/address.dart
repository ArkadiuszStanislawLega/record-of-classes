import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/db_model.dart';

import 'group.dart';

@Entity()
class Address implements DbModel {
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

  Address(
      {this.id = 0,
      this.street = '',
      this.houseNumber = '',
      this.flatNumber = '',
      this.city = ''});

  @override
  void addToDb() => ObjectBox.store.box<Address>().put(this);

  @override
  getFromDb() => ObjectBox.store.box<Address>().get(id);

  @override
  void update(updatedObject) => addToDb();

  @override
  void removeFromDb() => ObjectBox.store.box<Address>().remove(id);
}
