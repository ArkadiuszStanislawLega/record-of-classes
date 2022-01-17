import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/student.dart';
import 'package:record_of_classes/widgets/templates/snack_bar_info_template.dart';

class ParentOfStudentListItemTemplate extends StatelessWidget {
  ParentOfStudentListItemTemplate(
      {Key? key, required this.parent, required this.student})
      : super(key: key);
  late Parent parent;
  late Student student;
  late Store _store;

  @override
  Widget build(BuildContext context) {
    _store = objectBox.store;
    if (parent.person.target != null) {
      return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
              caption: Strings.DISCONNECT,
              color: Colors.deepOrange,
              icon: Icons.remove,
              onTap: () {
                removeParent();
                showInformationSnackBar(context);
              }),
        ],
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 7,
          child: ListTile(
            title: Text(parent.introduceYourself()),
            subtitle: Text(
                '${Strings.NUMBER_OF_CHILDREN}: ${parent.children.length.toString()}'),
            onTap: () {
              Navigator.pushNamed(context, AppUrls.DETAIL_PARENT,
                  arguments: parent);
            },
          ),
        ),
      );
    }
    return const Text('');
  }

  void showInformationSnackBar(BuildContext context) => SnackBarInfoTemplate(
      context: context,
      message:
          '${parent.introduceYourself()} ${Strings.AND} ${student.introduceYourself()} ${Strings.THEY_ARENT_FAMILY}');

  void removeParent() {
    parent.children.removeWhere((s) => s.id == student.id);
    student.parents.removeWhere((p) => p.id == parent.id);
    _store.box<Parent>().put(parent);
    _store.box<Student>().put(student);
  }
}
