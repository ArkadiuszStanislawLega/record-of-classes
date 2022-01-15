import 'package:flutter/material.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/widgets/templates/list_items/classes_list_item_template.dart';

class AllClassesListTemplate extends StatefulWidget {
  AllClassesListTemplate({Key? key, required this.classes}) : super(key: key);

  late List<Classes> classes;

  @override
  _AllClassesListTemplateState createState() => _AllClassesListTemplateState();
}

class _AllClassesListTemplateState extends State<AllClassesListTemplate> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.classes.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ClassesListItemTemplate(
            classes: widget.classes.elementAt(index));
      },
    );
  }
}
