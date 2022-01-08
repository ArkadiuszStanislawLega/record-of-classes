import 'package:flutter/material.dart';
import 'package:record_of_classes/models/group.dart';

class GroupListItemTemplate extends StatefulWidget {
  GroupListItemTemplate({Key? key, required this.group}) : super(key: key);
  Group group;

  @override
  _GroupListItemTemplateState createState() => _GroupListItemTemplateState();
}

class _GroupListItemTemplateState extends State<GroupListItemTemplate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(widget.group.name),
          Text(widget.group.address.target.toString())
        ],
      ),
    );
  }
}
