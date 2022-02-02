import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_doubles.dart';

class ItemContentTemplate extends StatelessWidget {
  const ItemContentTemplate({Key? key, required this.widgets})
      : super(key: key);

  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDoubles.paddings),
      child: Column(children: widgets),
    );
  }
}
