import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/db_model.dart';
import 'package:record_of_classes/models/person.dart';

@Entity()
class Phone extends DbModel {
  late int id;
  late int number;
  late String numberName;
  final owner = ToOne<Person>();

  Phone({this.id = 0, this.number = 0, this.numberName = ''}) {
    object = this;
    super.setId = id;
  }

  @override
  String toString() {
    return 'Nazwa kontaktu: $numberName, numer telefonu: $number';
  }
}
