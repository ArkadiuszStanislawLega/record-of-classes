import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_urls.dart';
import 'package:record_of_classes/models/student.dart';

class StudentsListItemTemplate extends StatefulWidget {
  const StudentsListItemTemplate({Key? key, required this.student})
      : super(key: key);
  final Student student;

  @override
  State<StatefulWidget> createState() {
    return _StudentsListItemTemplate();
  }
}

class _StudentsListItemTemplate extends State<StudentsListItemTemplate> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
    );
  }
}
