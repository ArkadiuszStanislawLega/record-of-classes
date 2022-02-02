import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/create/create_student_template.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class CreateStudentPage extends StatelessWidget {
  CreateStudentPage({Key? key}) : super(key: key);
  late Student _createdStudent;
  final CreateStudentTemplate _createStudentTemplate = CreateStudentTemplate();

  @override
  Widget build(BuildContext context) {
    Function addFunction =
        ModalRoute.of(context)!.settings.arguments as Function;
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.CREATE_STUDENT),
        ),
        body: Column(children: [
          _createStudentTemplate,
          ElevatedButton(
            onPressed: () => _onPressCreateButtonEvent(context),
            child: const Text(AppStrings.CREATE_STUDENT),
          ),
        ],),);
  }
  void _onPressCreateButtonEvent(BuildContext context) {
    _createdStudent = _createStudentTemplate.getStudent();
    objectBox.store.box<Student>().put(_createdStudent);
    _infoCreatedStudent(context);
    Navigator.pop(context);

  }
  void _infoCreatedStudent(BuildContext context) => SnackBarInfoTemplate(
      context: context,
      message:
      '${AppStrings.CREATE_STUDENT}: ${_createdStudent.introduceYourself()}!');

}
