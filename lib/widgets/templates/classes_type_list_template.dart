import 'package:flutter/material.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/widgets/templates/classes_type_list_item.dart';

class ClassesTypeListTemplate extends StatefulWidget {
  ClassesTypeListTemplate({Key? key, required this.classesTypes})
      : super(key: key);
  List<ClassesType> classesTypes;

  @override
  _ClassesTypeListTemplateState createState() =>
      _ClassesTypeListTemplateState();
}

class _ClassesTypeListTemplateState extends State<ClassesTypeListTemplate> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.classesTypes.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ClassesTypeListItem(
            classesType: widget.classesTypes.elementAt(index));
      },
    );
  }
}
