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
      {Key? key, required this.parent, required this.student, required this.removeFunction})
      : super(key: key);
  late Parent parent;
  late Student student;
  late Function removeFunction;

  @override
  Widget build(BuildContext context) {
    if (parent.person.target != null) {
      return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
              caption: Strings.DISCONNECT,
              color: Colors.deepOrange,
              icon: Icons.remove,
              onTap: () {
                removeFunction(parent);
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
}
