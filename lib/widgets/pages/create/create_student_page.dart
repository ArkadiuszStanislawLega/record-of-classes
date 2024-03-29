import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/create/create_student_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class CreateStudentPage extends StatelessWidget {
  CreateStudentPage({Key? key}) : super(key: key);
  late Student _createdStudent;
  final CreateStudentTemplate _createStudentTemplate = CreateStudentTemplate();
  late Function? _addFunction;

  @override
  Widget build(BuildContext context) {
    _addFunction = ModalRoute.of(context)!.settings.arguments as Function;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createStudent),
      ),
      body: Column(
        children: [
          _createStudentTemplate,
          ElevatedButton(
            onPressed: () => _onPressCreateButtonEvent(context),
            child: const Text(AppStrings.createStudent),
          ),
        ],
      ),
    );
  }

  void _onPressCreateButtonEvent(BuildContext context) {
    _createdStudent = _createStudentTemplate.getStudent();
    if (_addFunction == null) {
      _createdStudent = _createStudentTemplate.getStudent();
      _createdStudent.addToDb();
    } else {
      _addFunction!(_createdStudent);
    }
    _infoCreatedStudent(context);
    Navigator.pop(context);
  }

  void _infoCreatedStudent(BuildContext context) => SnackBarInfoTemplate(
      context: context,
      message:
          '${AppStrings.createStudent}: ${_createdStudent.introduceYourself()}!');
}
