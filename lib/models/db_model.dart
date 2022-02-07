import 'package:record_of_classes/main.dart';

class DbModel<T> {
  late T object;
  late int _id;

  T? getFromDb() => objectBox.store.box<T>().get(_id);

  void addToDb() => objectBox.store.box<T>().put(object);

  void removeFromDb() => objectBox.store.box<T>().remove(_id);

  set setId(int id){
    _id = id;
  }
}
