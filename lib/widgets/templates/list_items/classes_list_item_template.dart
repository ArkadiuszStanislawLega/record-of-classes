import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/classes.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class ClassesListItemTemplate extends StatelessWidget {
  ClassesListItemTemplate({Key? key, required this.classes}) : super(key: key);
  Classes classes;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: Strings.DELETE,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _updateDatabase();
            _showInfo(context);
          },
        ),
      ],
      child: ListTile(
          title: Text(classes.group.target!.name),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${classes.dateTime.day}.${classes.dateTime.month < 10 ? '0${classes.dateTime.month}' : classes.dateTime.month}.${classes.dateTime.year}'),
              Text(DateFormat.Hm().format(classes.dateTime))
            ],
          ),
          onTap: () {
            _navigateToGroupProfile(context);
          }),
    );
  }

  void _updateDatabase() {}

  void _navigateToGroupProfile(BuildContext context) =>
      Navigator.pushNamed(context, AppUrls.DETAIL_CLASSES, arguments: classes);

  void _showInfo(BuildContext context) => SnackBarInfoTemplate(
      context: context,
      message:
          '${Strings.GROUPS}: ${classes.group.target!.name} ${DateFormat.yQQQQ(classes.dateTime)} - ${Strings.REMOVED}!');
}
