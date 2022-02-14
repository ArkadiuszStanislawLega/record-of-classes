import 'package:flutter/material.dart';

class TextFieldTemplate extends StatefulWidget {
  TextFieldTemplate(
      {Key? key, required this.label, required this.hint, this.controller})
      : super(key: key);

  final String label, hint;
  late TextEditingController? controller;

  String _input = '';

  String get input {
    return _input;
  }

  @override
  _TextFieldTemplateState createState() => _TextFieldTemplateState();
}

class _TextFieldTemplateState extends State<TextFieldTemplate> {
  @override
  Widget build(BuildContext context) {
    widget.controller ??= TextEditingController();
    return TextField(
      style: Theme.of(context).textTheme.headline2,
      controller: widget.controller,
      decoration: InputDecoration(
          label:
              Text(widget.label, style: Theme.of(context).textTheme.headline2),
          hintText: widget.hint),
      onChanged: (String str) => str.isNotEmpty ? widget._input = str : {},
    );
  }
}
