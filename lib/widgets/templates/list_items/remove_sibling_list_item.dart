import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';
import 'package:record_of_classes/widgets/templates/student_list_tile_template.dart';

class RemoveSiblingListItem extends StatelessWidget {
  RemoveSiblingListItem(
      {Key? key, required this.student, required this.sibling})
      : super(key: key);
  Student student, sibling;

  @override
  Widget build(BuildContext context) {
    if (sibling.person.target != null) {
      return Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              caption: AppStrings.DISCONNECT,
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

    sibling.addToDb();
    student.addToDb();
  }

  void showInfoSnackBar(var context) => SnackBarInfoTemplate(
      context: context,
      message:
          '${sibling.introduceYourself()} ${AppStrings.AND} ${student.introduceYourself()} ${AppStrings.THEY_ARENT_SIBLINGS}');
}
