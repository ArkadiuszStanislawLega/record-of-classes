import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_colours.dart';
import 'package:record_of_classes/constants/app_doubles.dart';
import 'package:record_of_classes/models/classes.dart';

class ClassesItemTemplate extends StatefulWidget {
  const ClassesItemTemplate(
      {Key? key, required this.content, required this.classes})
      : super(key: key);

  final Widget content;
  final Classes classes;

  @override
  State<StatefulWidget> createState() {
    return _ClassesItemTemplate();
  }
}

class _ClassesItemTemplate extends State<ClassesItemTemplate> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.colorsOfTheMonth[widget.classes.dateTime.month],
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
          child: widget.content),
    );
  }
}
