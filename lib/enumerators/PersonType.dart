import 'package:record_of_classes/constants/strings.dart';

enum PersonType {
  none,
  teacher,
  student,
  parent
}

String ConverterPersonTypeToString(PersonType value){
  switch(value){
    case PersonType.none:
      return Strings.NONE_TYPE;
    case PersonType.teacher:
      return Strings.TEACHER;
    case PersonType.parent:
      return Strings.PARENT;
    case PersonType.student:
      return Strings.STUDENT;
  }
}
