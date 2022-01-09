import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';

class ParentListItemTemplate extends StatefulWidget {
  ParentListItemTemplate({Key? key, required this.parent, required this.student}) : super(key: key);
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
            title: Column(children: personData()), onTap: enterParentProfile),
      );
    }
    return const Text('');
  }

  void enterParentProfile() {
    Navigator.pushNamed(context, AppUrls.DETAIL_PARENT,
        arguments: widget.parent);
  }

  void removeParent() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.parent.person.target!.surname} ${widget.parent.person.target!.name} usuninięto z bazy danych!'),
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
      ),
    );
    var box = _store.box<Parent>();

   box.remove(widget.parent.id);
   box.remove(widget.parent.person.target!.id);
  }

  void addParent() {
    widget.student.parents.add(widget.parent);
    widget.parent.children.add(widget.student);
    _store.box<Student>().put(widget.student);
    _store.box<Parent>().put(widget.parent);

    var parentValues = '${widget.parent.person.target!.surname} ${widget.parent.person.target!.name}';
    var studentValues = '${widget.student.person.target!.surname} ${widget.student.person.target!.name}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$parentValues i $studentValues są teraz rodziną!'),
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
      ),
    );
  }

  List<Widget> personData() {
    var person = widget.parent.person.target!;
    return [
      Text('${person.surname} ${person.name} ',
        style: const TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.bold),
      ),
    ];
  }

}
