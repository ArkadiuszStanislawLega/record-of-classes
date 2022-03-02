import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class ParentListItemTemplate extends StatefulWidget {
  ParentListItemTemplate(
      {Key? key,
      required this.parent,
      required this.student,
      required this.addFunction,
      required this.removeFunction})
      : super(key: key);
  Parent parent;
  Student student;
  Function addFunction, removeFunction;

  @override
  State<StatefulWidget> createState() {
    return _ParentListItemTemplate();
  }
}

class _ParentListItemTemplate extends State<ParentListItemTemplate> {
  @override
  Widget build(BuildContext context) {
    if (widget.parent.person.target != null) {
      return Container(
        padding: const EdgeInsets.only(top: 10.0, right: 5.0, left: 5.0),
        child: Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
                caption: AppStrings.DELETE,
                color: Colors.red,
                icon: Icons.delete,
                onTap: removeParent),
            IconSlideAction(
                caption: AppStrings.ADD,
                color: Colors.green,
                icon: Icons.add,
                onTap: addParent),
          ],
          child: ListTile(
            title: Text(widget.parent.introduceYourself()),
            subtitle: Text(widget.parent.person.target!.phones.isNotEmpty
                ? widget.parent.person.target!.phones
                    .elementAt(0)
                    .number
                    .toString()
                : ''),
          ),
        ),
      );
    }
    return const Text('');
  }

  void enterParentProfile() {
    Navigator.pushNamed(context, AppUrls.DETAIL_PARENT,
        arguments: widget.parent);
  }

  void removeParent() {
    widget.removeFunction(widget.parent);
    SnackBarInfoTemplate(
        context: context,
        message:
            '${widget.parent.introduceYourself()} ${AppStrings.REMOVED_FROM_DATABASE}!');
  }

  void addParent() {
    widget.addFunction(widget.parent);
    SnackBarInfoTemplate(
        context: context,
        message:
            '${widget.parent.introduceYourself()} ${AppStrings.AND} ${widget.student.introduceYourself()} ${AppStrings.THEY_ARE_FAMILY_NOW}!');
  }
}
