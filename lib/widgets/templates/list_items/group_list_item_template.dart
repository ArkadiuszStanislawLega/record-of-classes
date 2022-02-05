import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class GroupListItemTemplate extends StatefulWidget {
  GroupListItemTemplate({Key? key, required this.group}) : super(key: key);
  Group group;

  @override
  _GroupListItemTemplateState createState() => _GroupListItemTemplateState();
}

class _GroupListItemTemplateState extends State<GroupListItemTemplate> {
  late Store _store;

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
            _updateDatabase();
            _showInfo(context);
          },
        ),
      ],
      child: ListTile(
          title: Text(widget.group.name),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  '${AppStrings.PERSONS_IN_GROUP}: ${widget.group.students.length.toString()}'),
              Text(widget.group.address.target.toString())
            ],
          ),
          onTap: _navigateToGroupProfile),
    );
  }

  void _updateDatabase() {
    setState(() {
      widget.group.removeFromDb();
    });
  }

  void _navigateToGroupProfile() =>
      Navigator.pushNamed(context, AppUrls.DETAIL_GROUP,
          arguments: widget.group);

  void _showInfo(BuildContext context) => SnackBarInfoTemplate(
      context: context,
      message:
          '${AppStrings.GROUP_OF_CLASSES}: ${widget.group.name} - ${AppStrings.REMOVED}!');
}
