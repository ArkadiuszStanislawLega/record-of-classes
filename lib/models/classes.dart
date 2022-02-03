import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/group.dart';

@Entity()
class Classes {
  late int id = 0;
  late DateTime dateTime;
  final group = ToOne<Group>();
  final attendances = ToMany<Attendance>();


  @override
  String toString() {
    return 'Classes{id: $id, dateTime: $dateTime, group: ${group.target!.name}, attendances: ${attendances.length}}';
  }

  void addToDb() => objectBox.store.box<Classes>().put(this);

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

  void removeFromDb(){
    group.target!.classes.removeWhere((classes) => classes.id == id);
    for (var attendance in attendances) {
      attendance.removeFromDb();
    }
    objectBox.store.box<Classes>().remove(id);
  }

  void addAttendance(Attendance attendance){
    attendances.add(attendance);
    objectBox.store.box<Classes>().put(this);
  }

  void removeClasses(int id){
    attendances.removeWhere((attendance) => attendance.id == id);
    objectBox.store.box<Classes>().put(this);
  }
}
