import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/student.dart';

class StudentsInGroupListItemTemplate extends StatefulWidget {
  StudentsInGroupListItemTemplate({Key? key, required this.group, required this.student}) : super(key: key);
  Group group;
  Student student;

  @override
  _StudentsInGroupListItemTemplateState createState() => _StudentsInGroupListItemTemplateState();
}

class _StudentsInGroupListItemTemplateState extends State<StudentsInGroupListItemTemplate> {
  late Store _store;
  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: Strings.DELETE,
          color: Colors.deepOrange,
          icon: Icons.remove,
          onTap: () {
            setState(() {
              widget.group.students.removeWhere((s) => s.id == widget.student.id);
              widget.student.groups.removeWhere((g) => g.id == widget.group.id);
              _store.box<Group>().put(widget.group);
              _store.box<Student>().put(widget.student);
            });
          },
        ),
      ],
      child: ListTile(
        title: Text(widget.student.introduceYourself()),
        onTap: () => Navigator.pushNamed(
          context,
          AppUrls.DETAIL_STUDENT,
          arguments: widget.student,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
  }
}
