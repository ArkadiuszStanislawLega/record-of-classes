import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/person.dart';

@Entity()
class Phone{
  late int id;
  late int number;
  late String numberName;
  final owner = ToOne<Person>();
}