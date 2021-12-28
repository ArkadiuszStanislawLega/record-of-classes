import 'package:objectbox/objectbox.dart';

@Entity()
class Person{
  late int id;
  late String name;
  late String surname;

  Person({this.id = 0, this.name = '', this.surname = ''});

  @override
  String toString() {
    return '$id. $name $surname';
  }
}