import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_colours.dart';
import 'package:record_of_classes/constants/app_doubles.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/group_item_template.dart';
import 'package:record_of_classes/widgets/templates/icon_in_card_template.dart';
import 'package:record_of_classes/widgets/templates/item_content_template.dart';
import 'package:record_of_classes/widgets/templates/item_title_template.dart';
import 'package:record_of_classes/widgets/templates/lists/property_in_one_row.dart';

class GroupTreeViewItemExpanded extends StatelessWidget {
  const GroupTreeViewItemExpanded({Key? key, required this.group})
      : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return GroupItemTemplate(
      content: Column(
        children: [_groupItemTitle(context), _groupItemContent(group)],
      ),
    );
  }

  Widget _groupItemTitle(BuildContext context) {
    return ItemTitleTemplate(
      widgets: [
        Text(
          group.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: AppDoubles.titleFontSize),
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
      Navigator.pushNamed(context, AppUrls.DETAIL_GROUP, arguments: group);

  Widget _groupItemContent(Group group) {
    return ItemContentTemplate(
      widgets: [
        Text(
          group.address.target!.toString(),
        ),
        PropertyInOneRow(
            property: AppStrings.NUMBER_OF_STUDENTS,
            value: group.students.length.toString()),
        PropertyInOneRow(
            property: AppStrings.NUMBER_OF_CLASSES,
            value: group.classes.length.toString())
      ],
    );
  }
}
