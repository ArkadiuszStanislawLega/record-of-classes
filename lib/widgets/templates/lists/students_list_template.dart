import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/list_items/students_list_item_template.dart';

class StudentsListTemplate extends StatefulWidget {
  const StudentsListTemplate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentsListTemplate();
  }
}

class _StudentsListTemplate extends State<StudentsListTemplate> {
  late Store _store;
  late Stream<List<Student>> _studentsStream;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: StreamBuilder<List<Student>>(
          stream: _studentsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(itemCount: snapshot.data!.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return StudentsListItemTemplate(student: snapshot.data!.elementAt(index));
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
    _studentsStream = _store
        .box<Student>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }
}
