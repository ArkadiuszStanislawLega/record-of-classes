import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/models/student.dart';

@Entity()
class Person{
  late int id;
  late String name;
  late String surname;
  final student = ToOne<Student>();

  Person({this.id = 0, this.name = '', this.surname = ''});

  @override
  String toString() {
    return '$id. $name $surname';
  }
}