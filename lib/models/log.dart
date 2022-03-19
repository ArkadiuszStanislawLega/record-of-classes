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
  late int actionType;
  late int modelType;
  late ActionType? eActionType;
  late ModelType? eModelType;
  late String valueBefore;
  late String value;

  int? get dbActionType {
    _ensureStableActionTypeEnumValues();
    return eActionType?.index;
  }

  set dbActionType(int? value) {
    _ensureStableActionTypeEnumValues();
    if (value == null) {
      eActionType = null;
    } else {
      eActionType =
          ActionType.values[value]; // throws a RangeError if not found

      // or if you want to handle unknown values gracefully:
      eActionType = value >= 0 && value < ActionType.values.length
          ? ActionType.values[value]
          : ActionType.none;
    }
  }

  int? get dbModelType {
    _ensureStableModelTypeEnumValues();
    return eModelType?.index;
  }

  set dbModelType(int? value) {
    _ensureStableModelTypeEnumValues();
    if (value == null) {
      eModelType = null;
    } else {
      eModelType = ModelType.values[value]; // throws a RangeError if not found

      // or if you want to handle unknown values gracefully:
      eModelType = value >= 0 && value < ModelType.values.length
          ? ModelType.values[value]
          : ModelType.none;
    }
  }

  void _ensureStableModelTypeEnumValues() {
    assert(ModelType.none.index == 0);
    assert(ModelType.account.index == 1);
    assert(ModelType.bill.index == 2);
  }

  void _ensureStableActionTypeEnumValues() {
    assert(ActionType.none.index == 0);
    assert(ActionType.add.index == 1);
    assert(ActionType.remove.index == 2);
    assert(ActionType.update.index == 3);
    assert(ActionType.create.index == 4);
    assert(ActionType.increase.index == 5);
    assert(ActionType.decrease.index == 6);
  }

  Log(
      {this.id = 0,
      this.participatingClassId = 0,
      this.actionType = 0,
      this.modelType = 0,
      this.value = '',
      this.eActionType = ActionType.none,
      this.eModelType = ModelType.none}) {
    date = DateTime.now();
    dbModelType = modelType;
    dbActionType = actionType;
  }

  @override
  String toString() {
    return '$id $date $participatingClassId $dbActionType $dbModelType $value';
  }

  @override
  void addToDb() {
    ObjectBox.store.box<Log>().put(this);
    print(ModelType.account.index);
    print(this);
  }

  @override
  getFromDb() {
    ObjectBox.store.box<Log>().get(id);
    print(this);
  }

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
