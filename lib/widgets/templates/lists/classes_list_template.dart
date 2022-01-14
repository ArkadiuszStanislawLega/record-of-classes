import 'package:flutter/material.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/widgets/templates/list_items/classes_list_item_template.dart';

class ClassesListTemplate extends StatefulWidget {
  ClassesListTemplate({Key? key, required this.classesList}) : super(key: key);

  List<Classes> classesList;

  @override
  _ClassesListTemplateState createState() => _ClassesListTemplateState();
}

class _ClassesListTemplateState extends State<ClassesListTemplate> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.classesList.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ClassesListItemTemplate(
            classes: widget.classesList.elementAt(index));
      },
    );
  }
}
