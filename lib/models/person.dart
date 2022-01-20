import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/enumerators/PersonType.dart';
import 'package:record_of_classes/models/phone.dart';
import 'package:record_of_classes/models/student.dart';

@Entity()
class Person{
  late int id;
  late String name;
  late String surname;
  late PersonType type;
  final student = ToOne<Student>();
  final phones = ToMany<Phone>();

  Person({this.id = 0, this.name = '', this.surname = ''});

  @override
  String toString() {
    return '$id. $name $surname';
  }

  String introduceYourself(){
    return '$surname $name';
  }
}