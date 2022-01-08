import 'package:flutter/material.dart';
import 'package:record_of_classes/models/group.dart';

class DetailGroupPage extends StatefulWidget {
  const DetailGroupPage({Key? key}) : super(key: key);

  @override
  _DetailGroupPageState createState() => _DetailGroupPageState();
}

class _DetailGroupPageState extends State<DetailGroupPage> {
  late Group group;

  @override
  Widget build(BuildContext context) {
    group = ModalRoute.of(context)!.settings.arguments as Group;
    return Scaffold(
      appBar: AppBar(
        title: Text(group.name),
      ),
      body: Column(
        children: [
          Text('Typ zajęć: ${group.classesType.target!.name}'),
          Text('Adres zajęć: ${group.address.target.toString()}'),
        ],
      ),
    );
  }
}
