import 'package:flutter/material.dart';

class OneRowPropertyTemplate extends StatefulWidget {
  OneRowPropertyTemplate({Key? key, required this.title, required this.value})
      : super(key: key);
  String title, value;

  @override
  _OneRowPropertyTemplateState createState() => _OneRowPropertyTemplateState();
}

class _OneRowPropertyTemplateState extends State<OneRowPropertyTemplate> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          widget.value,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
