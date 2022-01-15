import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';
import 'package:record_of_classes/widgets/templates/student_list_tile_template.dart';

class StudentsListItemTemplate extends StatefulWidget {
  final Student student;
  late Store _store;

  StudentsListItemTemplate({Key? key, required this.student})
      : super(key: key) {
    _store = objectBox.store;
  }

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
                caption: Strings.DELETE,
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => _actionOnTap(context)),
          ],
          child: StudentListTileTemplate(student: widget.student));
    }
    return const Text('');
  }

  void _actionOnTap(BuildContext context) {
    _updateDatabase();
    SnackBarInfoTemplate(
        context: context,
        message:
        '${Strings.DELETED_STUDENT}: ${widget.student.introduceYourself()}');
  }

  void _updateDatabase() {
    _removeAccountFromDb();
    _removeStudentFromDb();
    _removePersonFromDb();
  }

  void _removeAccountFromDb() => widget._store.box<Account>().remove(widget.student.account.targetId);

  void _removeStudentFromDb() =>
      widget._store.box<Student>().remove(widget.student.id);

  void _removePersonFromDb() =>
      widget._store.box<Person>().remove(widget.student.person.target!.id);
}
