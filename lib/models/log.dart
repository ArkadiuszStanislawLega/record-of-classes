import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/enumerators/ActionType.dart';
import 'package:record_of_classes/enumerators/ModelType.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/db_model.dart';

@Entity()
class Log implements DbModel {
  late int id;
  late int participatingClassId;
  late DateTime date;
  late ActionType actionType;
  late ModelType modelType;
  late String value;

  Log(
      {this.id = 0,
      this.participatingClassId = 0,
      this.actionType = ActionType.none,
      this.modelType = ModelType.none,
      this.value = ''}) {
    date = DateTime.now();
  }

  @override
  void addToDb() => ObjectBox.store.box<Log>().put(this);

  @override
  getFromDb() => ObjectBox.store.box<Log>().get(id);

  @override
  void removeFromDb() => ObjectBox.store.box<Log>().remove(id);

  @override
  void update(updatedObject) {
    participatingClassId = updatedObject.participatingClassId;
    actionType = updatedObject.actionType;
    value = updatedObject.value;
    addToDb();
  }
}
