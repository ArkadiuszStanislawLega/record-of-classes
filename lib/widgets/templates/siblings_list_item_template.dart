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
              _store.box<Student>().put(student);
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