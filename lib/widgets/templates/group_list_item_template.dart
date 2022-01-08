import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/group.dart';

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
          caption: Strings.DELETE,
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _store = objectBox.store;
            _store.box<Group>().remove(widget.group.id);
            _showInfo(context);
          },
        ),
      ],
      child: ListTile(
        title:
        Column(
          children: [
            Text(widget.group.name),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.group.classes.length.toString()),
                Text(widget.group.address.target.toString())
              ],)
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, AppUrls.DETAIL_GROUP, arguments: widget.group);
        },
      ),
    );
  }

  void _showInfo(var context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Grupa zajec: ${widget.group.name} - usunięta!'),
        duration: const Duration(milliseconds: 1500),
        width: 280.0,
        // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),);
  }
}
