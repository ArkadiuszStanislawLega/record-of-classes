import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_doubles.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/group_item_template.dart';

class GroupTreeViewItem extends StatelessWidget {
  const GroupTreeViewItem({Key? key, required this.group}) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return GroupItemTemplate(
      content: Container(
        padding: const EdgeInsets.all(AppDoubles.paddings),
        child: Text(
          group.name,
          style: const TextStyle(
              fontSize: AppDoubles.titleFontSize, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
