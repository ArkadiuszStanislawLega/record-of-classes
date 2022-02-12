import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class ClassesListItemTemplate extends StatelessWidget {
  ClassesListItemTemplate(
      {Key? key, required this.classes, this.removeFromDbFunction})
      : super(key: key);

  late Classes classes;
  late Function? removeFromDbFunction;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: AppStrings.DELETE,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            removeFromDbFunction!(classes);
            _showInfo(context);
          },
        ),
      ],
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        elevation: 7,
        child: ListTile(
          title: Text(classes.group.target!.name),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatDate(classes.dateTime)),
              Text(formatTime(classes.dateTime))
            ],
          ),
          onTap: () {
            _navigateToGroupProfile(context);
          },
        ),
      ),
    );
  }

  void _navigateToGroupProfile(BuildContext context) =>
      Navigator.pushNamed(context, AppUrls.DETAIL_CLASSES, arguments: {AppStrings.CLASSES : classes});

  void _showInfo(BuildContext context) => SnackBarInfoTemplate(
      context: context,
      message:
          '${AppStrings.GROUPS}: ${classes.group.target!.name} ${formatDate(classes.dateTime)} - ${AppStrings.REMOVED}!');
}
