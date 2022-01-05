import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';

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
        child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${person.surname} ${person.name} ',
                  style: const TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.bold),
                ),
                Text(' lat: ${sibling.age.toString()}')
              ],
            ),
            onTap: () => Navigator.pushNamed(context, AppUrls.DETAIL_STUDENT,
                arguments: sibling)),
      );
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

  void showInfoSnackBar(var context) {
    var siblingPerson = sibling.person.target!;
    var studentPerson = student.person.target!;
    var siblingValues = '${siblingPerson.surname} ${siblingPerson.name}';
    var studentValues = '${studentPerson.surname} ${studentPerson.name}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '$siblingValues ${Strings.AND} $studentValues ${Strings.THEY_ARENT_SIBLINGS}'),
        duration: const Duration(milliseconds: 1500),
        width: 280.0,
        // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
