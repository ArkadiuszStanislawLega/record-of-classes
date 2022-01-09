import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/student.dart';

class StudentListTileTemplate extends StatefulWidget {
  StudentListTileTemplate({Key? key, required this.student}) : super(key: key);
  late Student student;

  @override
  _StudentListTileTemplateState createState() =>
      _StudentListTileTemplateState();
}

class _StudentListTileTemplateState extends State<StudentListTileTemplate> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.student.introduceYourself()),
      subtitle: Text('${Strings.YEARS}: ${widget.student.age.toString()}'),
      onTap: _navigateToStudentProfile
    );
  }

  void _navigateToStudentProfile() => Navigator.pushNamed(context, AppUrls.DETAIL_STUDENT,
      arguments: widget.student);
}
