import 'package:flutter/material.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/list_items/students_in_group_list_item_template.dart';

class StudentsInGroupListTemplate extends StatefulWidget {
  StudentsInGroupListTemplate({Key? key, required this.group})
      : super(key: key);
  late Group group;

  @override
  _StudentsInGroupListTemplateState createState() =>
      _StudentsInGroupListTemplateState();
}

class _StudentsInGroupListTemplateState
    extends State<StudentsInGroupListTemplate> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.group.students.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return StudentsInGroupListItemTemplate(
            group: widget.group,
            student: widget.group.students.elementAt(index));
      },
    );
  }
}
