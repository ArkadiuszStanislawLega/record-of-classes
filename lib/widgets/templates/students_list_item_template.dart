import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:objectbox/objectbox.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/main.dart';
import 'package:record_of_classes/models/student.dart';

class StudentsListItemTemplate extends StatefulWidget {
  final Student student;
  late Store _store;

  StudentsListItemTemplate({Key? key, required this.student})
      : super(key: key){
    _store = objectBox.store;
  }


  @override
  State<StatefulWidget> createState() {
    return _StudentsListItemTemplate();
  }
}

class _StudentsListItemTemplate extends State<StudentsListItemTemplate> {

  @override
  Widget build(BuildContext context) {

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () {
          widget._store.box<Student>().remove(widget.student.id);
        },
      ), ],
      child: ListTile(
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          Text(
            '${widget.student.person.target!.surname} ${widget.student.person.target!.name} ',
            style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
          ),
          Text(' lat: ${widget.student.age.toString()}')
        ]),
        onTap: () {
          Navigator.pushNamed(context, AppUrls.DETAIL_STUDENT,
              arguments: widget.student);
        },
      ),
    );
  }
}
