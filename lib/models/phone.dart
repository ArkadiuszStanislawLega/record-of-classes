import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/db_model.dart';
import 'package:record_of_classes/models/person.dart';

@Entity()
class Phone implements DbModel {
  late int id;
  late int number;
  late String numberName;
  final owner = ToOne<Person>();

  Phone({this.id = 0, this.number = 0, this.numberName = ''});

  @override
  String toString() {
    return 'Nazwa kontaktu: $numberName, numer telefonu: $number';
  }

  @override
  void removeFromDb() {
    //TODO: removeFromDb
  }

  @override
  void addToDb() => objectBox.store.box<Phone>().put(this);

  @override
  getFromDb() => objectBox.store.box<Phone>().get(id);

  @override
  void update(updatedObject) => addToDb();
}
