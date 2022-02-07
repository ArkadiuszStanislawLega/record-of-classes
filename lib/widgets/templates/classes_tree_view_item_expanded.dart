import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_colours.dart';
import 'package:record_of_classes/constants/app_doubles.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/widgets/templates/classes_item_template.dart';
import 'package:record_of_classes/widgets/templates/icon_in_card_template.dart';
import 'package:record_of_classes/widgets/templates/item_content_template.dart';
import 'package:record_of_classes/widgets/templates/item_title_template.dart';
import 'package:record_of_classes/widgets/templates/lists/property_in_one_row.dart';

class ClassesTreeViewItemExpanded extends StatefulWidget {
  const ClassesTreeViewItemExpanded({Key? key, required this.classes})
      : super(key: key);

  final Classes classes;

  @override
  State<StatefulWidget> createState() {
    return _ClassesTreeViewItemExpanded();
  }
}

class _ClassesTreeViewItemExpanded extends State<ClassesTreeViewItemExpanded> {
  @override
  Widget build(BuildContext context) {
    return ClassesItemTemplate(
      classes: widget.classes,
      content: Column(
        children: [
          _classesItemTitle(context),
          _classesItemContent(),
        ],
      ),
    );
  }

  Widget _classesItemContent() {
    List<Widget> widgets = [];
    widgets.add(
      Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        child: PropertyInOneRow(
          property: AppStrings.PRESENTS_AT_THE_CLASSSES,
          value: widget.classes.presentStudentsNum.toString(),
        ),
      ),
    );
    for (var attendance in widget.classes.attendances) {
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(attendance.student.target!.introduceYourself()),
            attendance.bill.target!.isPaid
                ? const Icon(Icons.check_box)
                : const Icon(Icons.check_box_outline_blank),
          ],
        ),
      );
    }
    return ItemContentTemplate(widgets: widgets);
  }

  Widget _classesItemTitle(BuildContext context) {
    return ItemTitleTemplate(
      widgets: [
        Text(
          formatDate(widget.classes.dateTime),
          style: const TextStyle(
              fontSize: AppDoubles.titleFontSize, fontWeight: FontWeight.bold),
        ),
        Text(
          formatTime(widget.classes.dateTime),
          style: const TextStyle(
              fontSize: AppDoubles.titleFontSize, fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: () => _navigateToClassesDetailPage(context),
          child: IconInCardTemplate(
              icon: Icons.arrow_forward_ios_sharp,
              background: AppColors.navigateArrowBackground,
              foreground: AppColors.navigateButtonForeground),
        ),
      ],
    );
  }

  void _navigateToClassesDetailPage(BuildContext context) =>
      Navigator.pushNamed(context, AppUrls.DETAIL_CLASSES,
          arguments: widget.classes);
}
