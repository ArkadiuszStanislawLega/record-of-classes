import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/db_model.dart';
import 'package:record_of_classes/models/group.dart';

@Entity()
class Classes implements DbModel {
  late int id;
  late DateTime dateTime;
  final group = ToOne<Group>();
  final attendances = ToMany<Attendance>();

  Classes({this.id = 0});

  @override
  String toString() {
    return 'Classes{id: $id, dateTime: $dateTime, group: ${group.target!.name}, attendances: ${attendances.length}}';
  }

  String get name => group.target!.name;

  int get presentStudentsNum {
    int value = 0;
    for (var element in attendances) {
      if (element.isPresent) {
        value++;
      }
    }
    return value;
  }

  @override
  void removeFromDb() {
    group.target?.classes.removeWhere((classes) => classes.id == id);
    for (var attendance in attendances) {
      attendance.removeFromDb();
    }
    ObjectBox.store.box<Classes>().remove(id);
  }

  void addAttendance(Attendance attendance) {
    attendances.add(attendance);
    addToDb();
  }

  void removeClasses(int id) {
    attendances.removeWhere((attendance) => attendance.id == id);
    addToDb();
  }

  @override
  void addToDb() => ObjectBox.store.box<Classes>().put(this);

  @override
  getFromDb() => ObjectBox.store.box<Classes>().get(id);

  @override
  void update(updatedObject) => addToDb();
}
