import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/person.dart';
import 'package:record_of_classes/models/student.dart';

class SiblingsListItemTemplate extends StatelessWidget{
  SiblingsListItemTemplate({Key? key, required this.sibling, required this.student}) : super(key: key);
  Student sibling, student;
  late Store _store;

  @override
  Widget build(BuildContext context) {
    _store = objectBox.store;
    if (sibling.person.target != null) {
      Person person = sibling.person.target as Person;

      return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            caption: Strings.ADD,
            color: Colors.green,
            icon: Icons.add,
            onTap: () {
              student.siblings.add(sibling);
              sibling.siblings.add(student);
              var box = _store.box<Student>();
              box.put(student);
              box.put(sibling);

              var siblingValues = '${sibling.person.target!.surname} ${sibling.person.target!.name}';
              var studentValues = '${student.person.target!.surname} ${student.person.target!.name}';

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$siblingValues i $studentValues są teraz rodzeństwem!'),
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
            },
          ),
        ],
        child: ListTile(
          title:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              '${person.surname} ${person.name} ',
              style: const TextStyle(
                  color: Colors.blueGrey, fontWeight: FontWeight.bold),
            ),
            Text(' lat: ${sibling.age.toString()}')
          ]),
          onTap: () {
            Navigator.pushNamed(context, AppUrls.DETAIL_STUDENT,
                arguments: sibling);
          },
        ),
      );
    }
    return const Text('');
  }
}