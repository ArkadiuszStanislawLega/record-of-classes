import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';
import 'package:record_of_classes/widgets/templates/student_list_tile_template.dart';

class StudentsListItemTemplate extends StatefulWidget {
  final Student student;
  late Function removeFromDb, updateInDb;

  StudentsListItemTemplate({Key? key, required this.student, required this.removeFromDb, required this.updateInDb})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentsListItemTemplate();
  }
}

class _StudentsListItemTemplate extends State<StudentsListItemTemplate> {
  @override
  Widget build(BuildContext context) {
    if (widget.student.person.target != null) {
      return Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
                caption: AppStrings.delete,
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => _removeFromDatabase(context)),
          ],
          child: StudentListTileTemplate(student: widget.student, updatingFunction: widget.updateInDb,));
    }
    return const Text('');
  }

  void _removeFromDatabase(BuildContext context) {
    widget.removeFromDb(widget.student);
    SnackBarInfoTemplate(
        context: context,
        message:
            '${AppStrings.removedStudent}: ${widget.student.introduceYourself()}');
  }
}
