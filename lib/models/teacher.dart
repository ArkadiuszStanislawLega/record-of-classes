import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/db_model.dart';

import 'person.dart';

@Entity()
class Teacher extends DbModel{
  late int id;
  final person = ToOne<Person>();

  Teacher({this.id = 0}){
    object = this;
    super.setId = id;
  }
}
