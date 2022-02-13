import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_colours.dart';
import 'package:record_of_classes/constants/app_doubles.dart';

class GroupItemTemplate extends StatelessWidget {
  const GroupItemTemplate({Key? key, required this.content}) : super(key: key);
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppDoubles.groupElevation,
      margin: const EdgeInsets.all(AppDoubles.margins),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: AppColors.borderColor, width: AppDoubles.borderWidth),
        borderRadius: BorderRadius.circular(AppDoubles.cornerEdges),
      ),
      color: Colors.brown.shade200,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - AppDoubles.groupWidthInTreeView,
        child: content,
      ),
    );
  }
}
