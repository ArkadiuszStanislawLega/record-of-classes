import 'person.dart';

class Teacher {
  late int teacherId;
  late Person person;

  Teacher({required this.person, this.teacherId = 0});
}
