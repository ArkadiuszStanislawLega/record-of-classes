import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/strings.dart';
import 'package:record_of_classes/models/classes_type.dart';

class DetailClassesType extends StatefulWidget {
  DetailClassesType({Key? key}) : super(key: key);
  late ClassesType _classesType;
  @override
  _DetailClassesTypeState createState() => _DetailClassesTypeState();
}

class _DetailClassesTypeState extends State<DetailClassesType> {
  @override
  Widget build(BuildContext context) {
    widget._classesType = ModalRoute.of(context)!.settings.arguments as ClassesType;
    return Scaffold(
      appBar: AppBar(title: Text(widget._classesType.name),),
      body: Column(children: [
        Text('${Strings.PRICE_FOR_MONTH}: ${widget._classesType.priceForMonth.toString()}${Strings.CURRENCY}'),
        Text('${Strings.PRICE_FOR_EACH}: ${widget._classesType.priceForEach}${Strings.CURRENCY}'),
      ],),
    );
  }
}
