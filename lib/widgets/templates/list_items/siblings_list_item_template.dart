import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';
import 'package:record_of_classes/widgets/templates/student_list_tile_template.dart';

class SiblingsListItemTemplate extends StatelessWidget {
  SiblingsListItemTemplate(
      {Key? key, required this.sibling, required this.student})
      : super(key: key);
  Student sibling, student;
  late Store _store;

  @override
  Widget build(BuildContext context) {
    _store = objectBox.store;
    if (sibling.person.target != null) {
      return Slidable(
          actionPane: const SlidableDrawerActionPane(),
          secondaryActions: [
            IconSlideAction(
              caption: Strings.ADD,
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

  void updateDatabase() {
    student.siblings.add(sibling);
    sibling.siblings.add(student);
    var box = _store.box<Student>();
    box.put(student);
    box.put(sibling);
  }

  void showInfo(var context) {
    var siblingValues = sibling.person.target!.introduceYourself();
    var studentValues = student.person.target!.introduceYourself();

    SnackBarInfoTemplate(context: context, message: '$siblingValues ${Strings.AND} $studentValues ${Strings.THEY_ARE_SIBLINGS}!');
  }
}
