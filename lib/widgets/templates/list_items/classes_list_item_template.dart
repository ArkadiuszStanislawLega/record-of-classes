import 'package:flutter/material.dart';
import 'package:record_of_classes/models/classes.dart';

class ClassesListItemTemplate extends StatelessWidget {
  ClassesListItemTemplate({Key? key, required this.classes}) : super(key: key);
  Classes classes;

  @override
  Widget build(BuildContext context) {
    return Container(child: Text(classes.group.target!.name),);
  }
}
