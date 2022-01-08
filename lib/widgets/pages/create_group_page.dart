import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/classes_type.dart';
import 'package:record_of_classes/models/student.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late ClassesType _classesType;

  @override
  Widget build(BuildContext context) {
    _classesType = ModalRoute.of(context)!.settings.arguments as ClassesType;

    return Scaffold(
      appBar: AppBar(
        title: Text('${_classesType.name} - ${Strings.ADD_GROUP}'),
      ),
      body: Column(
        children: [
          Text('${_classesType.toString()}'),
        ],
      ),
    );
  }
}
