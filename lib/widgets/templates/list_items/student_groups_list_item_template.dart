import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/models/group.dart';

class StudentGroupListItemTemplate extends StatefulWidget {
  StudentGroupListItemTemplate({Key? key, required this.group})
      : super(key: key);
  Group group;

  @override
  _StudentGroupListItemTemplateState createState() =>
      _StudentGroupListItemTemplateState();
}

class _StudentGroupListItemTemplateState
    extends State<StudentGroupListItemTemplate> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.group.name),
      subtitle: Text(widget.group.address.target.toString()),
      onTap: _navigateToGroupProfile,
    );
  }

  void _navigateToGroupProfile() =>
      Navigator.pushNamed(context, AppUrls.DETAIL_GROUP,
          arguments: widget.group);
}
