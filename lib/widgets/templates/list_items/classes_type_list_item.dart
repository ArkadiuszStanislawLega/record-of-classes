import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class ClassesTypeListItem extends StatelessWidget {
  const ClassesTypeListItem({Key? key, required this.classesType}) : super(key: key);
  final ClassesType classesType;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: AppStrings.delete,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            classesType.removeFromDb();
            _showInfo(context);
          },
        ),
      ],
      child: Card(
        child: ListTile(
            title: Text(classesType.name, style: Theme.of(context).textTheme.headline4,),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('${AppStrings.priceForMonth}:'),
                    Text(
                        '${classesType.priceForMonth.toString()}${AppStrings.currency}')
                  ],
                ),
                Column(
                  children: [
                    const Text('${AppStrings.priceForEach}:'),
                    Text(
                        '${classesType.priceForEach.toString()}${AppStrings.currency}')
                  ],
                ),
              ],
            ),
            onTap: () => _navigateToDetailClassesProfile(context)),
      ),
    );
  }

  void _navigateToDetailClassesProfile(BuildContext context) =>
      Navigator.pushNamed(context, AppUrls.detailClassesType,
          arguments: {AppStrings.classesType: classesType});

  void _showInfo(BuildContext context) => SnackBarInfoTemplate(
      context: context,
      message:
          '${AppStrings.classesType}: ${classesType.name} - ${AppStrings.removed}!');
}
