import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/remove_sibling_list_item.dart';

class SiblingsListTemplate extends StatefulWidget {
  SiblingsListTemplate({Key? key, required this.student}) : super(key: key);
  Student student;

  @override
  State<StatefulWidget> createState() {
    return _SiblingsListTemplate();
  }
}

class _SiblingsListTemplate extends State<SiblingsListTemplate> {
  late Store _store;
  late Stream<List<Student>> _siblingsStream;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: StreamBuilder<List<Student>>(
        stream: _siblingsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            widget.student = _store.box<Student>().get(widget.student.id)!;
            return ListView.builder(
              itemCount: widget.student.siblings.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return RemoveSiblingListItem(
                    sibling: widget.student.siblings.elementAt(index), student: widget.student);
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
    _siblingsStream = _store
        .box<Student>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
