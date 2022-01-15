import 'package:flutter/material.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/widgets/templates/list_items/classes_list_item_template.dart';

class AllClassesTemplate extends StatefulWidget {
  AllClassesTemplate({Key? key, required this.classes}) : super(key: key);

  late List<Classes> classes;

  @override
  _AllClassesTemplateState createState() => _AllClassesTemplateState();
}

class _AllClassesTemplateState extends State<AllClassesTemplate> {
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
