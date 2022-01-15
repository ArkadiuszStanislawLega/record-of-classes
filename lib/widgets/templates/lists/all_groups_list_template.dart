import 'package:flutter/material.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/list_items/group_list_item_template.dart';

class AllGroupsTemplate extends StatefulWidget {
  AllGroupsTemplate({Key? key, required this.groups}) : super(key: key);
  List<Group> groups;


  @override
  _AllGroupsTemplateState createState() => _AllGroupsTemplateState();
}

class _AllGroupsTemplateState extends State<AllGroupsTemplate> {


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
            itemCount: widget.groups.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return GroupListItemTemplate(
                  group: widget.groups.elementAt(index));
            }
    );
  }
}
