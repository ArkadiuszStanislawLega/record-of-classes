import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/parent.dart';
import 'package:record_of_classes/models/student.dart';

class ParentOfStudentListItemTemplate extends StatelessWidget{
  ParentOfStudentListItemTemplate({Key? key, required this.parent, required this.student}) : super(key: key);
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
              onTap: (){
                removeParent();
                var parentValues = '${parent.person.target!.surname} ${parent.person.target!.name}';
                var studentValues = '${student.person.target!.surname} ${student.person.target!.name}';

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$parentValues i $studentValues nie są już rodziną!'),
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
              }),
        ],
        child: ListTile(
            title: Column(children: personData()), onTap: (){    Navigator.pushNamed(context, AppUrls.DETAIL_PARENT,
            arguments: parent);}),

      );
    }
    return const Text('');
  }

  void removeParent() {
    var box2 = _store.box<Parent>();
    parent.children.removeWhere((w) => w.id == student.id);
    box2.put(parent);


    var box = _store.box<Student>();
    student.parents.remove(parent);
    box.put(student);
  }

  List<Widget> personData() {
    var person = parent.person.target!;
    return [
      Text('${person.surname} ${person.name} ',
        style: const TextStyle(
            color: Colors.blueGrey, fontWeight: FontWeight.bold),
      ),
    ];
  }


}