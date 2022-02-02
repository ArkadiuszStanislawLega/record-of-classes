import 'package:record_of_classes/constants/app_strings.dart';

enum PersonType {
  none,
  teacher,
  student,
  parent
}

String ConverterPersonTypeToString(PersonType value){
  switch(value){
    case PersonType.none:
      return AppStrings.NONE_TYPE;
    case PersonType.teacher:
      return AppStrings.TEACHER;
    case PersonType.parent:
      return AppStrings.PARENT;
    case PersonType.student:
      return AppStrings.STUDENT;
  }
}
