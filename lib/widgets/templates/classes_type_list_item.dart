import 'package:flutter/material.dart';
import 'package:record_of_classes/models/classes_type.dart';

class ClassesTypeListItem extends StatelessWidget {
  const ClassesTypeListItem({Key? key, required this.classesType})
      : super(key: key);
  final ClassesType classesType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(classesType.name),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text('Za miesiąc: ${classesType.priceForMonth.toString()}zł'),
          Text('Za zajęcie: ${classesType.priceForEach.toString()}zł')
        ],)
      ],
    );
  }
}
