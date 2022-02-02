import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_colours.dart';
import 'package:record_of_classes/constants/app_doubles.dart';
import 'package:record_of_classes/models/classes.dart';

class ClassesItemTemplate extends StatelessWidget {
  const ClassesItemTemplate(
      {Key? key, required this.content, required this.classes})
      : super(key: key);

  final Widget content;
  final Classes classes;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.colorsOfTheMonth[classes.dateTime.month],
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: AppColors.borderColor, width: AppDoubles.borderWidth),
        borderRadius: BorderRadius.circular(AppDoubles.cornerEdges),
      ),
      margin: const EdgeInsets.symmetric(vertical: AppDoubles.margins),
      elevation: AppDoubles.classesElevation,
      child: SizedBox(
          width: MediaQuery.of(context).size.width -
              AppDoubles.classesWidthInTreeView,
          child: content),
    );
  }
}
