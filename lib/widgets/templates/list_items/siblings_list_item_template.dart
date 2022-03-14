import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:record_of_classes/constants/app_strings.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';
import 'package:record_of_classes/widgets/templates/student_list_tile_template.dart';

class SiblingsListItemTemplate extends StatelessWidget {
  SiblingsListItemTemplate(
      {Key? key, required this.sibling, required this.student, required this.addSiblingToDb})
      : super(key: key);
  Student sibling, student;
  Function addSiblingToDb;

  @override
  Widget build(BuildContext context) {
    if (sibling.person.target != null) {
      return Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              caption: AppStrings.add,
              color: Colors.green,
              icon: Icons.add,
              onTap: () {
                updateDatabase();
                showInfo(context);
              },
            ),
          ],
          child: StudentListTileTemplate(student: sibling));
    }
    return const Text('');
  }

  void updateDatabase() => addSiblingToDb(sibling: sibling);


  void showInfo(var context) {
    var siblingValues = sibling.person.target!.introduceYourself();
    var studentValues = student.person.target!.introduceYourself();

    SnackBarInfoTemplate(context: context, message: '$siblingValues ${AppStrings.and} $studentValues ${AppStrings.theyAreSiblings}!');
  }
}
