import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';
import 'package:record_of_classes/widgets/templates/student_list_tile_template.dart';

class RemoveSiblingListItem extends StatelessWidget {
  RemoveSiblingListItem(
      {Key? key, required this.student, required this.sibling})
      : super(key: key);
  Student student, sibling;
  late Store _store;

  @override
  Widget build(BuildContext context) {
    _store = objectBox.store;
    if (sibling.person.target != null) {
      Person person = sibling.person.target!;
      return Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              caption: Strings.DISCONNECT,
              color: Colors.deepOrange,
              icon: Icons.remove,
              onTap: () {
                updateDatabase();
                showInfoSnackBar(context);
              },
            ),
          ],
          child: StudentListTileTemplate(
            student: sibling,
          ));
    }
    return const Text('');
  }

  void updateDatabase() {
    student.siblings.removeWhere((s) => s.id == sibling.id);
    sibling.siblings.removeWhere((s) => s.id == student.id);

    var box = _store.box<Student>();

    box.put(sibling);
    box.put(student);
  }

  void showInfoSnackBar(var context) => SnackBarInfoTemplate(
      context: context,
      message:
          '${sibling.introduceYourself()} ${Strings.AND} ${student.introduceYourself()} ${Strings.THEY_ARENT_SIBLINGS}');
}
