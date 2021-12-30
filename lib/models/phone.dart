import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/person.dart';

@Entity()
class Phone {
  late int id;
  late int number;
  late String numberName;
  final owner = ToOne<Person>();

  Phone({this.id = 0, this.number = 0, this.numberName = ''});
}
