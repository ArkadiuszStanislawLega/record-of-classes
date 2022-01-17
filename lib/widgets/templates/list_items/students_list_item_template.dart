import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/account.dart';
import 'package:record_of_classes/models/attendance.dart';
import 'package:record_of_classes/models/bill.dart';
import 'package:record_of_classes/models/parent.dart';
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
    _removeAllRelations();
    _removeAccountFromDb();
    _removeStudentFromDb();
    _removePersonFromDb();
  }

  void _removeAllRelations() {
    _removeSiblingsRelationsFromDb();
    _removeParentsRelationsFromDb();
    _removeAttendanceRelationsFromDb();
    _removeGroupsRelationsFromDb();
    _commitChangesInDb();
  }

  void _removeSiblingsRelationsFromDb() {
    if (widget.student.siblings.isNotEmpty) {
      for (Student sibling in widget.student.siblings) {
        sibling.siblings
            .removeWhere((sibling) => sibling.id == widget.student.id);
      }

      widget.student.siblings.removeRange(
          0, widget.student.siblings.length - 1);
    }
  }

  void _removeParentsRelationsFromDb() {
    if (widget.student.parents.isNotEmpty) {
      for (Parent parent in widget.student.parents) {
        parent.children.removeWhere((children) =>
        children.id == widget.student.id);
      }
      widget.student.parents.removeRange(0, widget.student.parents.length - 1);
    }
  }

  void _removeAttendanceRelationsFromDb() {
    if (widget.student.attendancesList.isNotEmpty) {
      List<int> ids = [];
      for (Attendance attendance in widget.student.attendancesList) {
        ids.add(attendance.id);
      }
      widget._store.box<Attendance>().removeMany(ids);
    }
  }

  void _removeGroupsRelationsFromDb() =>
      widget.student.groups.removeRange(0, widget.student.groups.length - 1);

  void _commitChangesInDb() => widget._store.box<Student>().put(widget.student);

  void _removeAccountFromDb() {
    _removeRelatedBillsFromDb();
    widget._store.box<Account>().remove(widget.student.account.targetId);

  }

  void _removeRelatedBillsFromDb(){
    if(widget.student.account.target!.bills.isNotEmpty)
    {
      List<int> ids = [];
      for (var bill in widget.student.account.target!.bills) {
        ids.add(bill.id);
      }
      widget._store.box<Bill>().removeMany(ids);
    }
  }

  void _removeStudentFromDb() =>
      widget._store.box<Student>().remove(widget.student.id);

  void _removePersonFromDb() =>
      widget._store.box<Person>().remove(widget.student.person.target!.id);
}
