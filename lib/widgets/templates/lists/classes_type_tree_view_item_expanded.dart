import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_colours.dart';
import 'package:record_of_classes/constants/app_doubles.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/widgets/templates/classes_type_item_template.dart';
import 'package:record_of_classes/widgets/templates/item_content_template.dart';
import 'package:record_of_classes/widgets/templates/item_title_template.dart';

import 'property_in_one_row.dart';

class ClassesTypeTreeViewItemExpanded extends StatelessWidget {
  const ClassesTypeTreeViewItemExpanded({Key? key, required this.classesType})
      : super(key: key);
  final ClassesType classesType;

  @override
  Widget build(BuildContext context) {
    return ClassesTypeItemTemplate(
      content: Column(
        children: [_classesTypeItemTitle(context), _classesTypeItemContent()],
      ),
    );
  }

  Widget _classesTypeItemTitle(BuildContext context) {
    return ItemTitleTemplate(
      widgets: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
              top: AppDoubles.paddings, bottom: AppDoubles.paddings),
          child: Text(
            classesType.name,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppDoubles.titleFontSize),
          ),
        ),
        InkWell(
          onTap: () => _navigateToClassTypeDetailPage(
              context: context, classesType: classesType),
          child: _icon(
              Icons.arrow_forward_ios_sharp, AppColors.navigateArrowBackground,
              foreground: AppColors.navigateButtonForeground),
        ),
      ],
    );
  }

  Card _icon(IconData icon, Color background,
      {Color foreground = Colors.white}) {
    return Card(
      color: background,
      child: Icon(
        icon,
        color: foreground,
        size: AppDoubles.iconSize,
      ),
    );
  }

  Widget _classesTypeItemContent() {
    return ItemContentTemplate(
      widgets: [
        PropertyInOneRow(
            property: AppStrings.PRICE_FOR_MONTH,
            value:
                '${classesType.priceForMonth.toString()}${AppStrings.CURRENCY}'),
        PropertyInOneRow(
            property: AppStrings.PRICE_FOR_EACH,
            value:
                '${classesType.priceForEach.toString()}${AppStrings.CURRENCY}'),
        PropertyInOneRow(
            property: AppStrings.NUMBER_OF_GROUPS,
            value: classesType.groups.length.toString()),
      ],
    );
  }

  void _navigateToClassTypeDetailPage(
      {required BuildContext context, required ClassesType classesType}) {
    Navigator.pushNamed(context, AppUrls.DETAIL_CLASSES_TYPE,
        arguments: classesType);
  }
}
