import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_doubles.dart';

class ItemTitleTemplate extends StatelessWidget {
  const ItemTitleTemplate({Key? key, required this.widgets}) : super(key: key);

  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDoubles.cornerEdges),
          topRight: Radius.circular(AppDoubles.cornerEdges),
        ),
      ),
      padding: const EdgeInsets.all(AppDoubles.paddings),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: widgets),
    );
  }
}
