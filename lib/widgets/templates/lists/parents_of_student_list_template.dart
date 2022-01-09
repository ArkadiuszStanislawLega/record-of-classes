import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/list_items/parent_of_student_list_item_template.dart';

class ParentsOfStudentList extends StatefulWidget {
  ParentsOfStudentList({Key? key, required this.children}) : super(key: key);
  Student? children;

  @override
  State<StatefulWidget> createState() {
    return _ParentsOfStudentList();
  }
}

class _ParentsOfStudentList extends State<ParentsOfStudentList> {
  late Store _store;
  late Stream<List<Parent>> _parentsStream;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: StreamBuilder<List<Parent>>(
        stream: _parentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            widget.children = _store.box<Student>().get(widget.children!.id);
            return ListView.builder(
              itemCount: widget.children!.parents.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ParentOfStudentListItemTemplate(
                    parent: widget.children!.parents.elementAt(index), student: widget.children!,);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _store = objectBox.store;
    _parentsStream = _store
        .box<Parent>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}