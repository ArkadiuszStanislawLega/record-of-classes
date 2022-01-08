import 'package:flutter/material.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/group_list_item_template.dart';

class GroupListviewTemplate extends StatefulWidget {
  GroupListviewTemplate({Key? key, required this.groups}) : super(key: key);

  List<Group> groups;

  @override
  _GroupListviewTemplateState createState() => _GroupListviewTemplateState();
}

class _GroupListviewTemplateState extends State<GroupListviewTemplate> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.groups.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GroupListItemTemplate(group: widget.groups.elementAt(index));
      },
    );
  }
}
