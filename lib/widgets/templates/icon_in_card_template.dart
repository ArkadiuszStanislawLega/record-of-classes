import 'package:flutter/material.dart';
import 'package:record_of_classes/constants/app_doubles.dart';

class IconInCardTemplate extends StatelessWidget {
  const IconInCardTemplate(
      {Key? key,
      this.background = Colors.black,
      this.foreground = Colors.white,
      required this.icon,
      this.iconSize = AppDoubles.iconSize})
      : super(key: key);

  final Color background, foreground;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: background,
      child: Icon(
        icon,
        color: foreground,
        size: iconSize,
      ),
    );
  }
}
