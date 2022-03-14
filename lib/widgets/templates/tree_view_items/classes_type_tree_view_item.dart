import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_doubles.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/widgets/templates/classes_type_item_template.dart';

class ClassesTypeTreeViewItem extends StatelessWidget {
  const ClassesTypeTreeViewItem({Key? key, required this.classesType})
      : super(key: key);
  final ClassesType classesType;

  @override
  Widget build(BuildContext context) {
    return ClassesTypeItemTemplate(
      content: Container(
        padding: const EdgeInsets.all(AppDoubles.paddings),
        child: SizedBox(
          width: MediaQuery.of(context).size.width*0.8,
          child: Text(
            classesType.name,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ),
    );
  }
}
