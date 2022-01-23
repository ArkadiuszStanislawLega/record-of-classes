import 'package:flutter/material.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/attendance.dart';

class StudentAttendancesListItemTemplate extends StatelessWidget {
  StudentAttendancesListItemTemplate({Key? key, required this.attendance}) : super(key: key);
  late Attendance attendance;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(attendance.classes.target!.group.target!.name),
      subtitle: Text(formatDate(attendance.classes.target!.dateTime)),
    );
  }
}
