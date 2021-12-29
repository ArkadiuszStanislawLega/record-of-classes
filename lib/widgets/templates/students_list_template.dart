import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/student.dart';

class StudentsListTemplate extends StatefulWidget{
  const StudentsListTemplate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentsListTemplate();
  }

}

class _StudentsListTemplate extends State<StudentsListTemplate>{
  late Store _store;
  late Stream<List<Student>> _studentsStream;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder<List<Student>>(
        stream: _studentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DataTable(
              columns: const [
                DataColumn(
                  label: Text(Strings.ID),
                ),
                DataColumn(
                  label: Text(Strings.NAME),
                ),
                DataColumn(
                  label: Text(Strings.SURNAME),
                ),
                DataColumn(
                  label: Text(Strings.AGE),
                ),
              ],
              rows: snapshot.data!.map(
                    (student) {
                  return DataRow(cells: [
                    DataCell(
                      Text(student.id.toString()),
                    ),
                    DataCell(
                      Text(student.person.target!.name),
                    ),
                    DataCell(
                      Text(student.person.target!.surname),
                    ),
                    DataCell(
                      Text(student.age.toString()),
                    ),
                  ], onSelectChanged: (bool? changed){
                    if (changed == true){
                      Navigator.pushNamed(
                        context,
                        AppUrls.DETAIL_STUDENT,
                        arguments: student
                      );
                    }
                  });
                },
              ).toList(),
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