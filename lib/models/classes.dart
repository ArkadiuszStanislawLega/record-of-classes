import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/group.dart';

@Entity()
class Classes {
  late int id;
  late DateTime dateTime;
  final group = ToOne<Group>();
}
