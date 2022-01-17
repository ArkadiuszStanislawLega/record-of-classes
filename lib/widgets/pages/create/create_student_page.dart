import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/widgets/templates/create/create_student_template.dart';

class CreateStudentPage extends StatelessWidget {
  const CreateStudentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.CREATE_STUDENT),
      ),
      body: CreateStudentTemplate(),
    );
  }
}
