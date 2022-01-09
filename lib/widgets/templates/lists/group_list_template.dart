import 'package:flutter/material.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/list_items/group_list_item_template.dart';

class GroupListTemplate extends StatefulWidget {
  GroupListTemplate({Key? key, required this.groups}) : super(key: key);

  late List<Group> groups;

  @override
  _GroupListTemplateState createState() => _GroupListTemplateState();
}

class _GroupListTemplateState extends State<GroupListTemplate> {
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
