import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/group.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/list_items/student_groups_list_item_template.dart';

class StudentGroupListTemplate extends StatefulWidget {
  StudentGroupListTemplate({Key? key, required this.student}) : super(key: key);
  late Student student;

  @override
  _StudentGroupListTemplateState createState() =>
      _StudentGroupListTemplateState();
}

class _StudentGroupListTemplateState extends State<StudentGroupListTemplate> {
  late Store _store;
  late Stream<List<Group>> _groupsStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Group>>(
      stream: _groupsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: widget.student.groups.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return StudentGroupListItemTemplate(
                  group: widget.student.groups.elementAt(index));
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _groupsStream = _store
        .box<Group>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
