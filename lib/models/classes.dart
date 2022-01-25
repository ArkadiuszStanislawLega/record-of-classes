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


  void addClassesToDb(){
    objectBox.store.box<Classes>().put(this);
  }
}
