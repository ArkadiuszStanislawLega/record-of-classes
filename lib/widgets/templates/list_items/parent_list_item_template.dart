import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/phone.dart';
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
  @override
  Widget build(BuildContext context) {
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
          subtitle: Text(widget.parent.person.target!.phones.isNotEmpty
              ? widget.parent.person.target!.phones.elementAt(0).number.toString()
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
    _removeParentFromStudentInDatabase();
    SnackBarInfoTemplate(
        context: context,
        message:
            '${widget.parent.introduceYourself()} ${Strings.REMOVED_FROM_DATABASE}!');
  }

  void _removeParentFromStudentInDatabase() {
    setState(() {
      var parentBox = objectBox.store.box<Parent>();
      var personBox = objectBox.store.box<Person>();
      var phoneBox = objectBox.store.box<Phone>();

      widget.student.parents
          .removeWhere((element) => element.id == widget.parent.id);
      widget.parent.children
          .removeWhere((element) => element.id == widget.student.id);

      for (var element in widget.parent.person.target!.phones) {
        phoneBox.remove(element.id);
      }
      widget.parent.person.target!.phones
          .removeWhere((element) => element.owner.targetId == widget.parent.id);

      parentBox.remove(widget.parent.id);
      personBox.remove(widget.parent.person.target!.id);
    });
  }

  void _addParentToStudentInDatabase() {
    widget.student.parents.add(widget.parent);
    widget.parent.children.add(widget.student);
    objectBox.store.box<Student>().put(widget.student);
    objectBox.store.box<Parent>().put(widget.parent);
  }

  void addParent() {
    _addParentToStudentInDatabase();
    SnackBarInfoTemplate(
        context: context,
        message:
            '${widget.parent.introduceYourself()} ${Strings.AND} ${widget.student.introduceYourself()} ${Strings.THEY_ARE_FAMILY_NOW}!');
  }
}
