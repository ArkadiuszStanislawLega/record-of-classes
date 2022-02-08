import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/db_model.dart';

import 'person.dart';

@Entity()
class Teacher implements DbModel{
  late int id;
  final person = ToOne<Person>();

  Teacher({this.id = 0});
  @override
  void removeFromDb() {
    // TODO: implement removeFromDb
  }

  @override
  void addToDb() => objectBox.store.box<Teacher>().put(this);

  @override
  getFromDb() => objectBox.store.box<Teacher>().get(id);

  @override
  void update(updatedObject) => addToDb();
}
