import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_colours.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/group_item_template.dart';
import 'package:record_of_classes/widgets/templates/icon_in_card_template.dart';
import 'package:record_of_classes/widgets/templates/item_content_template.dart';
import 'package:record_of_classes/widgets/templates/item_title_template.dart';
import 'package:record_of_classes/widgets/templates/property_in_one_row.dart';

class GroupTreeViewItemExpanded extends StatefulWidget {
  GroupTreeViewItemExpanded({Key? key, required this.group}) : super(key: key);

  late Group group;

  @override
  State<StatefulWidget> createState() {
    return _GroupTreeViewItemExpanded();
  }
}

class _GroupTreeViewItemExpanded extends State<GroupTreeViewItemExpanded> {
  @override
  Widget build(BuildContext context) {
    return GroupItemTemplate(
      content: Column(
        children: [_groupItemTitle(context), _groupItemContent(widget.group)],
      ),
    );
  }

  Widget _groupItemTitle(BuildContext context) {
    return ItemTitleTemplate(
      widgets: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Text(widget.group.name,
              textAlign:TextAlign.left,
              style: Theme.of(context).textTheme.headline3),
        ),
        InkWell(
          onTap: () => _navigateToGroupDetailPage(context),
          child: IconInCardTemplate(
              icon: Icons.arrow_forward_ios_sharp,
              background: AppColors.navigateArrowBackground,
              foreground: AppColors.navigateButtonForeground),
        ),
      ],
    );
  }

  void _navigateToGroupDetailPage(BuildContext context) =>
      Navigator.pushNamed(context, AppUrls.detailGroup, arguments: {
        AppStrings.group: widget.group,
        AppStrings.function: _updateGroup
      });

  void _updateGroup(Group updated) {
    setState(() {
      widget.group = updated;
    });
  }

  Widget _groupItemContent(Group group) {
    return ItemContentTemplate(
      widgets: [
        Text(
          group.address.target!.toString(),
          style: Theme.of(context).textTheme.headline2,
        ),
        Column(
          children: [
            PropertyInOneRow(
                property: AppStrings.numberOfStudents,
                value: group.students.length.toString()),
            PropertyInOneRow(
                property: AppStrings.numberOfClasses,
                value: group.classes.length.toString())
          ],
        )
      ],
    );
  }
}
