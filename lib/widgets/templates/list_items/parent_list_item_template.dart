import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class ParentListItemTemplate extends StatefulWidget {
  ParentListItemTemplate(
      {Key? key, required this.parent, required this.student})
      : super(key: key);
  Parent parent;
  Student student;

  @override
  State<StatefulWidget> createState() {
    return _ParentListItemTemplate();
  }
}

class _ParentListItemTemplate extends State<ParentListItemTemplate> {
  late Store _store;

  @override
  Widget build(BuildContext context) {
    _store = objectBox.store;
    if (widget.parent.person.target != null) {
      return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
              caption: Strings.DELETE,
              color: Colors.red,
              icon: Icons.delete,
              onTap: removeParent),
          IconSlideAction(
              caption: Strings.ADD,
              color: Colors.green,
              icon: Icons.add,
              onTap: addParent),
        ],
        child: ListTile(
          title: Text(widget.parent.introduceYourself()),
          subtitle: Text(widget.parent.phone.isNotEmpty
              ? widget.parent.phone.elementAt(0).number.toString()
              : ''),
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
    SnackBarInfoTemplate(
        context: context,
        message:
            '${widget.parent.introduceYourself()} ${Strings.REMOVED_FROM_DATABASE}!');
    _removeParentFromStudentInDatabase();
  }

  void _removeParentFromStudentInDatabase() {
    var box = _store.box<Parent>();

    box.remove(widget.parent.id);
    box.remove(widget.parent.person.target!.id);
  }

  void _addParentToStudentInDatabase() {
    widget.student.parents.add(widget.parent);
    widget.parent.children.add(widget.student);
    _store.box<Student>().put(widget.student);
    _store.box<Parent>().put(widget.parent);
  }

  void addParent() {
    _addParentToStudentInDatabase();
    SnackBarInfoTemplate(
        context: context,
        message:
            '${widget.parent.introduceYourself()} ${Strings.AND} ${widget.student.introduceYourself()} ${Strings.THEY_ARE_FAMILY_NOW}!');
  }
}
