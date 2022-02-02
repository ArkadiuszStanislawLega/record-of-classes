import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/student.dart';

class StudentListTileTemplate extends StatefulWidget {
  StudentListTileTemplate({Key? key, required this.student, this.updatingFunction}) : super(key: key);
  late Student student;
  late Function? updatingFunction;

  @override
  _StudentListTileTemplateState createState() =>
      _StudentListTileTemplateState();
}

class _StudentListTileTemplateState extends State<StudentListTileTemplate> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 7,
      child: ListTile(
        title: Text(widget.student.introduceYourself()),
        subtitle: Text('${AppStrings.YEARS}: ${widget.student.age.toString()}'),
        onTap: _navigateToStudentProfile,
      ),
    );
  }

  void _navigateToStudentProfile() =>
      Navigator.pushNamed(context, AppUrls.DETAIL_STUDENT,
          arguments: {AppStrings.STUDENT : widget.student,
          AppStrings.FUNCTION : widget.updatingFunction});
}
