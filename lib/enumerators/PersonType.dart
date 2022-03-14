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
      return AppStrings.noneType;
    case PersonType.teacher:
      return AppStrings.teacher;
    case PersonType.parent:
      return AppStrings.parent;
    case PersonType.student:
      return AppStrings.student;
  }
}
