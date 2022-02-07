import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_doubles.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/widgets/templates/classes_item_template.dart';

class ClassesTreeViewItem extends StatefulWidget {
  const ClassesTreeViewItem({Key? key, required this.classes})
      : super(key: key);

  final Classes classes;

  @override
  State<StatefulWidget> createState() {
    return _ClassesTreeViewItem();
  }

}

class _ClassesTreeViewItem extends State<ClassesTreeViewItem>{
  @override
  Widget build(BuildContext context) {
    return ClassesItemTemplate(
      classes: widget.classes,
      content: Container(
        padding: const EdgeInsets.all(AppDoubles.paddings),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatDate(widget.classes.dateTime),
              style: const TextStyle(
                  fontSize: AppDoubles.titleFontSize,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              formatTime(widget.classes.dateTime),
              style: const TextStyle(
                  fontSize: AppDoubles.titleFontSize,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

}
